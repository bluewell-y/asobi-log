require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  test "未ログインで投稿ページを開くとログイン画面へリダイレクトする" do
    get new_place_review_path(places(:one))
    assert_redirected_to new_session_path
  end

  test "ログイン中は口コミを投稿できる" do
    login_as(users(:two))
    assert_difference "Review.count", 1 do
      post place_reviews_path(places(:one)), params: {review: {rating: 4, comment: "楽しかったです"}}
    end
    assert_redirected_to place_path(places(:one))
  end

  test "評価が星2つ以下でコメントが空だと投稿できない" do
    login_as(users(:two))
    assert_no_difference "Review.count" do
      post place_reviews_path(places(:one)), params: {review: {rating: 1, comment: ""}}
    end
    assert_response :unprocessable_entity
  end

  test "投稿者本人は編集画面を開ける" do
    login_as(users(:one))
    get edit_place_review_path(places(:one), reviews(:one))
    assert_response :success
  end

  test "投稿者以外が編集画面を開くと詳細ページへリダイレクトする" do
    login_as(users(:two))
    get edit_place_review_path(places(:one), reviews(:one))
    assert_redirected_to place_path(places(:one))
  end

  test "投稿者本人は口コミを更新できる" do
    login_as(users(:one))
    patch place_review_path(places(:one), reviews(:one)), params: {review: {comment: "更新後のコメント"}}
    assert_redirected_to place_path(places(:one))
    assert_equal "更新後のコメント", reviews(:one).reload.comment
  end

  test "投稿者本人は口コミを削除できる" do
    login_as(users(:one))
    assert_difference "Review.count", -1 do
      delete place_review_path(places(:one), reviews(:one))
    end
    assert_redirected_to place_path(places(:one))
  end

  test "投稿者以外は削除できない" do
    login_as(users(:two))
    assert_no_difference "Review.count" do
      delete place_review_path(places(:one), reviews(:one))
    end
    assert_redirected_to place_path(places(:one))
  end
end
