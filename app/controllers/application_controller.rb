class ApplicationController < ActionController::Base
  def user_signed_in?
    if cookies.signed[:user].present?
      redirect_to(root_path)
    end
  end

  # def authenticate_user!
  #   if cookies.signed[:user].blank?
  #     redirect_to(sessions_path)
  #   end
  # end

  def aws_credential
    Aws.config.update({
      region: Rails.application.credentials.AWS_S3[:Region],
      credentials: Aws::Credentials.new(
        Rails.application.credentials.AWS_S3[:Access_Key_ID],
        Rails.application.credentials.AWS_S3[:Secret_Access_Key]
      )
    })
  end

  def presign_url(key, time)
    Aws::S3::Presigner.new.presigned_url(
      :get_object,
      bucket: 'radio-archives',
      key: key,
      expires_in: time
    )
  end
end
