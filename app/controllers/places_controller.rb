class PlacesController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy, :remove_sub_image]
  before_action :set_place, only: [:show, :edit, :update, :destroy, :remove_sub_image]
  before_action :require_owner, only: [:edit, :update, :destroy, :remove_sub_image]

  def index
    @places = Place.with_attached_cover_image
                    .keyword_search(params[:keyword])
                    .by_category(params[:category])
                    .by_indoor_outdoor(params[:indoor_outdoor])
                    .for_age(params[:age])

    # 一覧カードに表示する状態マーク用（未ログイン時は空）
    @favorite_place_ids = logged_in? ? current_user.favorite_places.ids : []
    @visited_place_ids  = logged_in? ? current_user.visited_places.ids : []
  end

  def show
  end

  def new
    @place = Place.new
  end                                                                 

  def create
    @place = current_user.places.new(place_params)
    if @place.save
      redirect_to @place, notice: "遊び場を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit                                                                                               
  end

  def update                                                          
    if @place.update(place_params_for_update)                                                            
      attach_new_sub_images
      redirect_to @place, notice: "遊び場を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @place.destroy
    redirect_to places_path, notice: "遊び場を削除しました"
  end

  def remove_sub_image
    @place.sub_images_attachments.find(params[:attachment_id]).purge
    redirect_to edit_place_path(@place), notice: "参考画像を削除しました"
  end

  private

  def set_place                                                       
    @place = Place.find(params[:id])
  end

  def require_owner
    unless @place.user == current_user
      redirect_to places_path, alert: "この操作を行う権限がありません"
    end
  end

  def place_params
    params.require(:place).permit(:name, :cover_image, :description, :address, :category, :indoor_outdoor, :min_age, :max_age, :price, :business_hours, sub_images: [])
  end

  # 編集時、トップ画像を選び直さなかった場合は既存の添付を消さないようにする。
  # 参考画像は update 内で個別に扱うので、常に除外する。
  def place_params_for_update
    permitted = place_params
    permitted.delete(:cover_image) if permitted[:cover_image].blank?
    permitted.delete(:sub_images)
    permitted
  end

  # 編集フォームで新しく選ばれた参考画像を、既存を消さずに追加する
  def attach_new_sub_images
    new_images = params.dig(:place, :sub_images)&.compact_blank
    @place.sub_images.attach(new_images) if new_images.present?
  end
end