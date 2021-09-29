class ProgramSelectsController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    if params[:program] == 'JODV_FAV-FOUR'
      client = aws_credential
      objects = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents

      @programs = Array.new
      objects.each do |object|
        object_detail = client.get_object({bucket: Rails.application.credentials.AWS_S3[:Bucket], key: object.key}).to_h
        if object_detail[:metadata]['program'] == 'FAV FOUR'
          @programs.push({key: object.key, date: object_detail[:metadata]['date']})
        end
      end
      @programs.reverse!
    end
  end
end
