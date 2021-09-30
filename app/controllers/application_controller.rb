class ApplicationController < ActionController::Base
  def authenticate_user!
    if cookies.signed[:user].present?
      @user = User.new(id: cookies.signed[:user]['id']).signed_in?
    elsif cookies.signed[:user].blank?
      redirect_to(sessions_path)
    end
  end

  def user_signed_in?
    if cookies.signed[:user].present? && User.new(id: cookies.signed[:user]['id']).signed_in?.present?
      redirect_to(root_path)
    end
  end

  def aws_s3_client
    Aws::S3::Client.new(
      access_key_id: Rails.application.credentials.AWS_S3[:Access_Key_ID],
      secret_access_key: Rails.application.credentials.AWS_S3[:Secret_Access_Key],
      region: Rails.application.credentials.AWS_S3[:Region]
    )
  end

  def aws_s3_object(key)
    Aws::S3::Object.new(
      access_key_id: Rails.application.credentials.AWS_S3[:Access_Key_ID],
      secret_access_key: Rails.application.credentials.AWS_S3[:Secret_Access_Key],
      region: Rails.application.credentials.AWS_S3[:Region],
      bucket_name: Rails.application.credentials.AWS_S3[:Bucket],
      key: key
    )
  end
end
