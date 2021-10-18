class PlayersController < ApplicationController
  before_action :authenticate_user!

  def show
    if cookies.signed[:already].blank? && params[:play] == 'shuffle_play'
      cookies.signed[:already] = { value: Array.new(24), expires: 1.day.from_now }
    elsif cookies.signed[:already].blank? && params[:play] == 'one_month' || params[:play] == 'three_months'
      cookies.signed[:already] = { value: Array.new(4), expires: 1.day.from_now }
    end

    client = aws_s3_client
    object = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents.sample
    object_client = aws_s3_object(object.key)

    already_play = cookies.signed[:already]
    play_song = Piston2438.repeat_shuffle(client, object, object_client, params[:play], already_play)

    already_play.push(play_song[:object].key)
    already_play.shift
    cookies.signed[:already] = already_play

    @audio_url = "https://d1tr04ubbr03km.cloudfront.net/#{play_song[:object].key}"
    @date = Date.parse(play_song[:object_client].metadata['date']).strftime('%Y年 %m月 %d日')
  end

  def update
    @program = Program.create_or_find_by(s3_key: params[:key])

    if params[:already].to_i == 0
      @program.update(already_play: true)
    elsif params[:already].to_i == 1
      @program.update(already_play: false)
    end

    redirect_to(players_path(program: params[:program], key: params[:key]))
  end

  def destroy
    cookies.delete(:already)
    redirect_to(program_selects_path(program: 'JOAV_MIX-MACHINE'))
  end
end
