class ApplicationController < ActionController::Base
  def authenticate_user!
    if cookies.signed[:user].blank? || User.new(id: cookies.signed[:user]['id']).signed_in?.blank?
      redirect_to(sessions_path)
    end
  end

  def user_signed_in?
    if User.new(id: cookies.signed[:user]['id']).signed_in?.present?
      redirect_to(root_path)
    end
  end

  def aws_credential
    Aws::S3::Client.new(
      region: Rails.application.credentials.AWS_S3[:Region],
      access_key_id: Rails.application.credentials.AWS_S3[:Access_Key_ID],
      secret_access_key: Rails.application.credentials.AWS_S3[:Secret_Access_Key]
    )
  end
end
