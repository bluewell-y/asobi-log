class SitemapsController < ApplicationController
  def show
    @places = Place.order(:id)
    @users = User.order(:id)
  end
end
