class Admin::DeletionRequestsController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_deletion_request, only: [:approve, :reject]

  def index
    @deletion_requests = DeletionRequest.pending.includes(:place, :user).order(created_at: :asc)
  end

  def approve
    @deletion_request.place.destroy
    redirect_to admin_deletion_requests_path, notice: "遊び場を削除しました"
  end

  def reject
    @deletion_request.update!(status: :rejected)
    redirect_to admin_deletion_requests_path, notice: "削除申請を却下しました"
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "この操作を行う権限がありません"
    end
  end

  def set_deletion_request
    @deletion_request = DeletionRequest.find(params[:id])
  end
end
