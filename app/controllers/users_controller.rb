class UsersController < ApplicationController
  before_action :user_signed_in? , only: :index

  def index
    @user = User.new
  end

  def create
    user = User.find_by(email: user_params[:email].downcase)
    if user != nil && user.password == user_params[:password]
      cookies.signed[:user] = {
        value: {
          id: user.id,
        }, expires: 7.days
      }

      redirect_to(root_path)
    else
      render(action: 'index')
    end
  end

  def destroy
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
