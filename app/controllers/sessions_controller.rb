class SessionsController < ApplicationController
  before_action :user_signed_in?, only: :index

  def index
    @user = User.new
  end

  def create
    email = user_params[:email].downcase
      /@/ =~ email
      email_account = $`
      email_domain = $'

    secret_key = Rails.application.credentials.User[:Secret_Key]
    encrypt_email_account = User.connection.select_all("SELECT HEX(AES_ENCRYPT('#{email_account}', '#{secret_key}'));").rows[0][0]
    encrypt_email = "#{encrypt_email_account}@#{email_domain}"
    encrypt_password = User.connection.select_all("SELECT HEX(AES_ENCRYPT('#{user_params[:password]}', '#{secret_key}'));").rows[0][0]

    user = User.find_by(encrypt_email: encrypt_email)
    if user.blank? || encrypt_password != user.encrypt_password
      render(action: 'new')
    else
      cookies.signed[:user] = {
        value: {
          id: user.id,
        }, expires: 3.days
      }

      redirect_to(sessions_path)
    end
  end

  def destroy
    cookies.signed[:user] = nil
    redirect_to(sessions_path)
  end

  private
    def user_signed_in?
      unless cookies.signed[:user].blank?
        redirect_to(root_path)
      end
    end

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
