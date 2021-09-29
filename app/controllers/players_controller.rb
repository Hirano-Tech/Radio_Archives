class PlayersController < ApplicationController
  before_action :authenticate_user!

  def show
    client = aws_credential

    if params[:program] == 'JOAV_MIX-MACHINE'
      if cookies.signed[:already].blank?
        cookies.signed[:already] = { value: Array.new(10), expires: 1.day.from_now }
      end

      if Rails.env.production?
        object = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents.sample
        object_detail = client.get_object({bucket: Rails.application.credentials.AWS_S3[:Bucket], key: object.key}).to_h

        already_play = cookies.signed[:already]
        while object_detail[:metadata]['program'] != 'Piston2438_DJ-MIX' || already_play.include?(object.key)
          object = client.list_objects_v2({bucket: 'joav.dj-mixes'}).contents.sample
          object_detail = client.get_object({bucket: 'joav.dj-mixes', key: object.key}).to_h
        end

        already_play.push(object.key)
        already_play.shift
        cookies.signed[:already] = already_play

        @audio_url = "https://d1tr04ubbr03km.cloudfront.net/#{object.key}"
        @date = Date.parse(object_detail[:metadata]['date']).strftime('%Y年 %m月 %d日')
      elsif Rails.env.development?
        # @audio_url = 'https://d1tr04ubbr03km.cloudfront.net/.mp3'
        # @date = Date.parse('').strftime('%Y年 %m月 %d日')
      end

    elsif params[:program] == 'JODV_FAV-FOUR'
      @program = Program.create_or_find_by(s3_key: params[:key])
      @audio_url = "https://d1tr04ubbr03km.cloudfront.net/#{params[:key]}"

      if Rails.env.production?
        object_detail = client.get_object({bucket: Rails.application.credentials.AWS_S3[:Bucket], key: params[:key]}).to_h
        @date = Date.parse(object_detail[:metadata]['date']).strftime('%Y年 %m月 %d日')
      elsif Rails.env.development?
        # @date = Date.parse('').strftime('%Y年 %m月 %d日')
      end
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
