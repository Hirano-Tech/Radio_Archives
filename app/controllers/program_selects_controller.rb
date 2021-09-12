class ProgramSelectsController < ApplicationController
  before_action :authenticate_user

  def index
    unless cookies.signed[:program].blank?
      @programs = Program.select(:id, :on_air, :already_play).readonly

      aws_credential
      @image_url = presign_url('images/BRIDGESTONE DRIVE TO THE FUTURE.webp', 60)
    end
  end

  def show
    @program = Program.find(params[:id].to_i)

    aws_credential
    @image_url = presign_url('images/BRIDGESTONE DRIVE TO THE FUTURE.webp', 60)
    @audio_url = presign_url(@program.s3_key, 3600)
  end

  def play
    if request.post?
      Program.update(params[:id].to_i, already_play: true)
      redirect_to program_select_path(id: params[:id].to_i)
    elsif request.delete?
      Program.update(params[:id].to_i, already_play: false)
      redirect_to program_select_path(id: params[:id].to_i)
    end
  end

  def create
    redirect_to program_select_path(id: date_params[:broadcast_date].to_i)
  end

  def confirm
    if program_params[:commit] == 'BRIDGESTONE DRIVE TO THE FUTURE'
      cookies.signed[:program] = {
        value: {
          name: 'JOAV_Sun_19:00',
        }, expires: 1.day
      }
    end

    redirect_to program_selects_path
  end

  def destroy_cookie
    cookies.signed[:program] = nil
    redirect_to program_selects_path
  end

  private
  def authenticate_user
    if cookies.signed[:user].blank?
      redirect_to(users_path)
    end
  end

  def program_params
    params.permit(:commit)
  end

  def date_params
    params.permit(:broadcast_date)
  end

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
