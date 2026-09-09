require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  test "未ログインで一覧を開くとログイン画面へリダイレクトする" do
    get favorites_path
    assert_redirected_to new_session_path
  end

  test "ログイン中はお気に入り一覧を表示できる" do
    login_as(users(:one))
    get favorites_path
    assert_response :success
  end

  test "お気に入りに追加できる" do
    login_as(users(:two))
    assert_difference "Favorite.count", 1 do
      post place_favorite_path(places(:one))
    end
    assert_redirected_to place_path(places(:one))
  end

  test "同じ遊び場は二重にお気に入り登録されない" do
    login_as(users(:two))
    post place_favorite_path(places(:one))
    assert_no_difference "Favorite.count" do
      post place_favorite_path(places(:one))
    end
  end

  test "お気に入りを解除できる" do
    login_as(users(:one))
    assert_difference "Favorite.count", -1 do
      delete place_favorite_path(places(:one))
    end
    assert_redirected_to place_path(places(:one))
  end
end
