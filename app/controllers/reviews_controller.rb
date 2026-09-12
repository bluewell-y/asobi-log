class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_place
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :require_author, only: [:edit, :update, :destroy]

  def new
    @review = @place.reviews.new
  end

  def create
    @review = @place.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @place, notice: "口コミを投稿しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to @place, notice: "口コミを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to @place, notice: "口コミを削除しました"
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end

  def set_review
    @review = @place.reviews.find(params[:id])
  end

  def require_author
    unless @review.user == current_user
      redirect_to @place, alert: "この操作を行う権限がありません"
    end
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
