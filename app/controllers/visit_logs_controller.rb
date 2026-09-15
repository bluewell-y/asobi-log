class VisitLogsController < ApplicationController
  before_action :require_login
  before_action :set_place, only: [:index, :new, :create, :edit, :update, :destroy, :remove_photo]
  before_action :set_visit_log, only: [:edit, :update, :destroy, :remove_photo]
  before_action :require_author, only: [:edit, :update, :destroy, :remove_photo]

  def index
    @visit_logs = if @place
      current_user.visit_logs.where(place: @place).order(visited_on: :desc)
    else
      current_user.visit_logs.includes(:place).order(visited_on: :desc)
    end
  end

  def new
    @visit_log = @place.visit_logs.new
  end

  def create
    @visit_log = @place.visit_logs.new(visit_log_params)
    @visit_log.user = current_user
    if @visit_log.save
      redirect_to @place, notice: "訪問記録をつけました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @visit_log.update(visit_log_params_for_update)
      attach_new_photos
      redirect_to @place, notice: "訪問記録を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @visit_log.destroy
    redirect_to @place, notice: "訪問記録を削除しました"
  end

  def remove_photo
    @visit_log.photos.find(params[:attachment_id]).purge
    redirect_to edit_place_visit_log_path(@place, @visit_log), notice: "写真を削除しました"
  end

  private

  def set_place
    @place = Place.find(params[:place_id]) if params[:place_id]
  end

  def set_visit_log
    @visit_log = @place.visit_logs.find(params[:id])
  end

  def require_author
    unless @visit_log.user == current_user
      redirect_to @place, alert: "この操作を行う権限がありません"
    end
  end

  def visit_log_params
    params.require(:visit_log).permit(:visited_on, :weather, :satisfaction, :companion, :memo, photos: [])
  end

  # 編集時は既存の写真を消さないよう、写真は常に除外する（新しい写真は別途追加する）
  def visit_log_params_for_update
    visit_log_params.except(:photos)
  end

  # 編集フォームで新しく選ばれた写真を、既存を消さずに追加する
  def attach_new_photos
    new_photos = params.dig(:visit_log, :photos)&.compact_blank
    @visit_log.photos.attach(new_photos) if new_photos.present?
  end
end
