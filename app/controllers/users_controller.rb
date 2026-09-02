class UsersController < ApplicationController
  before_action :require_login, only: [:mypage, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "会員登録が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def mypage
    @places = current_user.places
    @favorite_count = current_user.favorites.count
    @visit_count = current_user.visits.count
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(user_update_params)
      redirect_to mypage_path, notice: "プロフィールを更新しました"
    else
      @user = current_user
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "退会しました"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    permitted = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    permitted.reject! { |_, v| v.blank? } if permitted[:password].blank?
    permitted
  end
end