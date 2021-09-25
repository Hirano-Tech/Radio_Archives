class PlayersController < ApplicationController
  before_action :authenticate_user!

  def show
    if request.query_string.include?('shuffle_play')
      if cookies.signed[:already].blank?
        cookies.signed[:already] = { value: Array.new(10), expires: 1.day.from_now }
      end

      client = aws_credential
      object = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents.sample
      object_detail = client.get_object({bucket: Rails.application.credentials.AWS_S3[:Bucket], key: object.key}).to_h

      already_play = cookies.signed[:already]
      while object_detail[:content_type] != 'audio/mp3' || already_play.include?(object.key)
        object = client.list_objects_v2({bucket: 'joav.dj-mixes'}).contents.sample
        object_detail = client.get_object({bucket: 'joav.dj-mixes', key: object.key}).to_h
      end

      already_play.push(object.key)
      already_play.shift
      cookies.signed[:already] = already_play

      @audio_url = "https://d1tr04ubbr03km.cloudfront.net/#{object.key}"
      @date = Date.parse(object_detail[:metadata]['date']).strftime('%Y年 %m月 %d日')
    end
  end
end
