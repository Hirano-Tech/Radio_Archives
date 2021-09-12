class Piston2438PlayersController < ApplicationController
  before_action :authenticate_user

  def index
    aws_credential
    @image_url = presign_url('images/GROOVE LINE.webp', 60)
  end

  def create
    if params[:play_method] == '全曲シャッフル再生'
      songs = Program.where(category_id: 2).select(:id).readonly

      @play_list = Array.new
      songs.each do |song|
        @play_list << song.id
      end

      session[:play_list] = @play_list.shuffle
      redirect_to piston2438_player_path(id: session[:play_list].shift)
    end
  end

  def show
    session[:play_list].shuffle!

    aws_credential
    @image_url = presign_url('images/GROOVE LINE.webp', 60)

    @program = Program.readonly.find(params[:id].to_i)
    @audio_url = presign_url(@program.s3_key, 1800)
  end
end
