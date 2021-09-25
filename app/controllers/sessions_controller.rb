class SessionsController < ApplicationController
  before_action :user_signed_in?, only: :index

  def index
  end

  def create
    email_address = User.get_email_account(user_params[:email].downcase)

    encrypt_email_account = User.encrypt_email(email_address[:account])
    encrypt_email = "#{encrypt_email_account}@#{email_address[:domain]}"
    encrypt_password = User.encrypt_password(user_params[:password])

    login_user = User.new(encrypt_email: encrypt_email, encrypt_password: encrypt_password)
    user = login_user.user_sign_in

    if user.blank?
      redirect_to(sessions_path)
    else
      cookies.signed[:user] = {
        value: {
          id: user.id,
        }, expires: 3.days
      }

      redirect_to(root_path)
    end
  end

  def destroy
    cookies.delete(:already)
    cookies.delete(:user)
    redirect_to(sessions_path)
  end

  private
    def user_params
      params.permit(:email, :password)
    end
end
