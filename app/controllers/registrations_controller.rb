class RegistrationsController < ApplicationController
  before_action :user_signed_in?, only: [:index, :new]
  before_action :cookie_hold?, only: :index

  def index
    @encrypt_email = cookies.signed[:user_confirm]['email']
    @encrypt_password = cookies.signed[:user_confirm]['password']

    /@/ =~ @encrypt_email
      encrypt_email_account = $`
      email_domain = $'

    secret_key = Rails.application.credentials.User[:Secret_Key]
    email_account = User.connection.select_all("SELECT convert( AES_DECRYPT( UNHEX('#{encrypt_email_account}'), '#{secret_key}') USING 'utf8mb4')").rows[0][0]
    @email = "#{email_account}@#{email_domain}"
    @password = User.connection.select_all("SELECT convert( AES_DECRYPT( UNHEX('#{@encrypt_password}'), '#{secret_key}') USING 'utf8mb4')").rows[0][0]
  end

  def new
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

    cookies.signed[:user_confirm] = {
      value: {
        email: encrypt_email,
        password: encrypt_password
      }, expires: 1.day
    }

    redirect_to(registrations_path)
  end

  def destroy
    cookies.signed[:user_confirm] = nil
    redirect_to(sessions_path)
  end

  private
    def user_signed_in?
      unless cookies.signed[:user].blank?
        redirect_to(root_path)
      end
    end

    def cookie_hold?
      if cookies.signed[:user_confirm].blank?
        redirect_to(new_registration_path)
      end
    end

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
