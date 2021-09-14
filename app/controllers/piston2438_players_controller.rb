class Piston2438PlayersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]

  def index
    aws_credential
    @image_url = presign_url('images/GROOVE LINE.webp', 60)
  end

  def create
    if params[:play_method] == '全曲シャッフル再生'
      songs = Program.where(category_id: 2).select(:id, :on_air).reorder('on_air DESC').readonly

      @play_list = Array.new
      songs.each do |song|
        @play_list << song.id
      end

      session[:play_list] = @play_list.shuffle
      redirect_to piston2438_player_path(id: session[:play_list][0])
    end
  end

  def show
    unless session[:play_list].length == 0
      aws_credential
      @image_url = presign_url('images/GROOVE LINE.webp', 60)

      @program = Program.select(:id, :s3_key, :on_air, :category_id).readonly.includes(:category).find(params[:id].to_i)
      @audio_url = presign_url(@program.s3_key, 1800)

      session[:play_list].delete_at(0)
      session[:play_list].shuffle!
    else
      redirect_to(root_path)
    end
  end

  private
    def authenticate_user!
      if cookies.signed[:user].blank?
        redirect_to(sessions_path)
      end
    end
end
