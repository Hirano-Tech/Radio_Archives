class PlayersController < ApplicationController
  before_action :authenticate_user!

  def show
    if cookies.signed[:already].blank? && params[:play] == 'shuffle_play'
      cookies.signed[:already] = { value: Array.new(24), expires: 1.day.from_now }
    elsif cookies.signed[:already].blank? && params[:play] == 'one_month' || params[:play] == 'three_months'
      cookies.signed[:already] = { value: Array.new(4), expires: 1.day.from_now }
    end

    already_play = cookies.signed[:already]
    client = aws_s3_client
    objects = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents
    objects.delete_if do |object|
      object_client = aws_s3_object(object.key)

      program = object_client.metadata['program'] != 'Piston2438_DJ-MIX'
      if params[:play] == 'shuffle_play'
        program || already_play.include?(object.key)
      elsif params[:play] == 'one_month'
        program || Date.parse(object_client.metadata['date']) < Date.today.months_ago(1) || already_play.include?(object.key)
      elsif params[:play] == 'three_months'
        program || Date.parse(object_client.metadata['date']) < Date.today.months_ago(3) || already_play.include?(object.key)
      end
    end

    play_song = objects.sample

    already_play.push(play_song.key)
    already_play.shift
    cookies.signed[:already] = already_play

    @audio_url = "https://d1tr04ubbr03km.cloudfront.net/#{play_song.key}"
    object_client = aws_s3_object(play_song.key)
    @date = Date.parse(object_client.metadata['date']).strftime('%Y年 %m月 %d日')
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
