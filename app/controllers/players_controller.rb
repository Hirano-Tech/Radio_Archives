class PlayersController < ApplicationController
  before_action :authenticate_user!

  def show
    if params[:program] == 'JOAV_MIX-MACHINE'
      if cookies.signed[:already].blank?
        cookies.signed[:already] = { value: Array.new(10), expires: 1.day.from_now }
      end

      client = aws_s3_client
      object = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents.sample
      object_client = aws_s3_object(object.key)

      already_play = cookies.signed[:already]
      while object_client.metadata['program'] != 'Piston2438_DJ-MIX' || already_play.include?(object.key)
        object = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents.sample
        object_client = aws_s3_object(object.key)
      end

      already_play.push(object.key)
      already_play.shift
      cookies.signed[:already] = already_play

      @audio_url = "https://d1tr04ubbr03km.cloudfront.net/#{object.key}"
      @date = Date.parse(object_client.metadata['date']).strftime('%Y年 %m月 %d日')

    elsif params[:program] == 'JODV_FAV-FOUR'
      @program = Program.create_or_find_by(s3_key: params[:key])
      @audio_url = "https://d1tr04ubbr03km.cloudfront.net/#{params[:key]}"
      @date = Date.parse(aws_s3_object(params[:key]).metadata['date']).strftime('%Y年 %m月 %d日')
    end
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
end
