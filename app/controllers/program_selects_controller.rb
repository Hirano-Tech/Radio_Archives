class ProgramSelectsController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    if params[:program] == 'JODV_FAV-FOUR'
      client = aws_s3_client
      objects = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents

      @programs = Array.new
      objects.each do |object|
        object_client = aws_s3_object(object.key)

        if object_client.metadata['program'] == 'FAV FOUR'
          @programs.push({key: object.key, date: object_client.metadata['date']})
        end
      end
      @programs.reverse!
    end
  end
end
