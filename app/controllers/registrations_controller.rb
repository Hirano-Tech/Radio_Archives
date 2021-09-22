class RegistrationsController < ApplicationController
  before_action :user_signed_in?, only: [:index, :new]

  def index
    if cookies.signed[:regist_user].present?
      @encrypt_email = cookies.signed[:regist_user]['encrypt_email']
      @encrypt_password = cookies.signed[:regist_user]['encrypt_password']

      encrypt_email_address = User.get_email_account(@encrypt_email)

      decrypt_email_account = User.decrypt_email(encrypt_email_address[:account])
      @email = "#{decrypt_email_account}@#{encrypt_email_address[:domain]}"
      @password = User.decrypt_password(@encrypt_password)
    else
      redirect_to(new_registration_path)
    end
  end

  def new
    cookies.delete(:regist_user)
  end

  def create
    email_address = User.get_email_account(user_params[:email].downcase)

    encrypt_email_account = User.encrypt_email(email_address[:account])
    encrypt_email = "#{encrypt_email_account}@#{email_address[:domain]}"
    encrypt_password = User.encrypt_password(user_params[:password])

    cookies.signed[:regist_user] = {
      value: {
        encrypt_email: encrypt_email,
        encrypt_password: encrypt_password
      }, expires: 5.minutes
    }

    redirect_to(registrations_path)
  end

  def destroy
    cookies.delete(:regist_user)
    redirect_to(sessions_path)
  end

  private
    def user_signed_in?
      unless cookies.signed[:user].blank?
        redirect_to(root_path)
      end
    end

    def user_params
      params.permit(:email, :password)
    end
end
