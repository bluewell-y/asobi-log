class DeletionRequestsController < ApplicationController
  before_action :require_login
  before_action :set_place

  def new
    @deletion_request = @place.deletion_requests.new
  end

  def create
    @deletion_request = @place.deletion_requests.new(deletion_request_params)
    @deletion_request.user = current_user
    if @deletion_request.save
      redirect_to @place, notice: "削除を申請しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end

  def deletion_request_params
    params.require(:deletion_request).permit(:reason)
  end
end
