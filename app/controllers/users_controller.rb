class UsersController < ApplicationController
  def index
    @user = User.new
  end

  def create
    user = User.find_by(email: user_params[:email].downcase)
    if user != nil && user.password == user_params[:password]
      cookies.signed[:user] = {
        value: {
          id: user.id,
        }, expires: 1.day
      }

      redirect_to(program_selects_path)
    else
      render(action: 'index')
    end
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
