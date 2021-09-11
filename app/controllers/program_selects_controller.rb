class ProgramSelectsController < ApplicationController
  def index
    unless cookies.signed[:program].blank?
      Aws.config.update({
        region: Rails.application.credentials.AWS_S3[:Region],
        credentials: Aws::Credentials.new(
          Rails.application.credentials.AWS_S3[:Access_Key_ID],
          Rails.application.credentials.AWS_S3[:Secret_Access_Key]
        )
      })

      @image_url = Aws::S3::Presigner.new.presigned_url(
        :get_object,
        bucket: 'radio-archives',
        key: 'images/BRIDGESTONE DRIVE TO THE FUTURE.webp',
        expires_in: 10
      )

      @programs = Program.select(:id, :on_air, :already_play).readonly
    end
  end

  def show
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

  private
  def program_params
    params.permit(:commit)
  end

  def date_params
    params.permit(:broadcast_date)
  end
end
