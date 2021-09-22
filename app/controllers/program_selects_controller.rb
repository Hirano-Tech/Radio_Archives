class ProgramSelectsController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    session[:play_lists] = nil

    if request.query_string.include?('MIX-MACHINE')
      aws_credential
      @image_url = presign_url('images/GROOVE LINE.webp', 60)
    else
    end
  end

  def create
    play_method = play_params[:play_method]

    if play_method == '全曲シャッフル再生'
      songs = Program.new(category_id: 2).get_all_mixes
    elsif play_method == '期間指定'
      start_date = Date.parse("#{play_params['start_date(1i)']}-#{play_params['start_date(2i)']}-01").beginning_of_month
      end_date = Date.parse("#{play_params['end_date(1i)']}-#{play_params['end_date(2i)']}-01").end_of_month

      songs = Program.new(on_air: start_date...end_date, category_id: 2).get_period_mixes
    end

    @play_lists = Array.new
    songs.each do |song|
      @play_lists << song.id
    end

    session[:play_lists] = @play_lists.shuffle!
    redirect_to program_select_path(id: session[:play_lists].shift)
  end

  def show
    if session[:play_lists].present?
      aws_credential
      @image_url = presign_url('images/GROOVE LINE.webp', 60)

      @program = Program.select(:id, :s3_key, :on_air, :category_id).readonly.includes(:category).find(params[:id].to_i)
      @audio_url = presign_url(@program.s3_key, 1800)
    else
      redirect_to(root_path)
    end
  end

  # def confirm
  #   if params[:commit] == 'MIX MACHINE From. GROOVE LINE'
  #     create_cookies_program('JOAV_Mon_18:30')
  #     redirect_to piston2438_players_path
  #   elsif params[:commit] == 'BRIDGESTONE DRIVE TO THE FUTURE'
  #     create_cookies_program('JOAV_Sun_19:00')
  #     redirect_to program_selects_path
  #   end
  # end

  # def play
  #   if request.post?
  #     Program.update(params[:id].to_i, already_play: true)
  #     redirect_to program_select_path(id: params[:id].to_i)
  #   elsif request.delete?
  #     Program.update(params[:id].to_i, already_play: false)
  #     redirect_to program_select_path(id: params[:id].to_i)
  #   end
  # end

  # def destroy
  #   cookies.signed[:program] = nil
  #   redirect_to root_path
  # end

  private

    def play_params
      params.permit(:play_method, 'start_date(1i)', 'start_date(2i)', 'end_date(1i)', 'end_date(2i)')
    end

    # def create_cookies_program(value)
    #   cookies.signed[:program] = {
    #     value: {
    #       name: value,
    #     }, expires: 1.day
    #   }
    # end

    # def date_params
    #   params.permit(:broadcast_date)
    # end
end
