class FavoritesController < ApplicationController
  before_action :require_login

  def index
    @favorite_places = current_user.favorite_places
  end

  def create
    place = Place.find(params[:place_id])
    current_user.favorites.find_or_create_by(place: place)
    redirect_to place, notice: "お気に入りに追加しました"
  end

  def destroy
    place = Place.find(params[:place_id])
    current_user.favorites.find_by(place: place)&.destroy
    redirect_to place, notice: "お気に入りを解除しました"
  end
end
