class PlacesController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  before_action :require_owner, only: [:edit, :update, :destroy]

  def index
    @places = Place.all
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
    if @place.update(place_params)
      redirect_to @place, notice: "遊び場を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @place.destroy
    redirect_to places_path, notice: "遊び場を削除しました"
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
    params.require(:place).permit(:name, :description, :address, :category, :indoor_outdoor, :min_age, :max_age, :price, :business_hours)
  end
end