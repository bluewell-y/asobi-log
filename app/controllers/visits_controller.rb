class VisitsController < ApplicationController
  before_action :require_login

  def index
    @visited_places = current_user.visited_places
  end

  def create
    place = Place.find(params[:place_id])
    current_user.visits.find_or_create_by(place: place) do |visit|
      visit.visited_on = Date.today
    end
    redirect_to place, notice: "「行った」を記録しました"
  end

  def destroy
    place = Place.find(params[:place_id])
    current_user.visits.find_by(place: place)&.destroy
    redirect_to place, notice: "「行った」記録を解除しました"
  end
end
