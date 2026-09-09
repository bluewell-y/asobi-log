require "test_helper"

class VisitsControllerTest < ActionDispatch::IntegrationTest
  test "未ログインで一覧を開くとログイン画面へリダイレクトする" do
    get visits_path
    assert_redirected_to new_session_path
  end

  test "ログイン中は行った場所一覧を表示できる" do
    login_as(users(:one))
    get visits_path
    assert_response :success
  end

  test "「行った」を記録できる" do
    login_as(users(:two))
    assert_difference "Visit.count", 1 do
      post place_visit_path(places(:one))
    end
    assert_redirected_to place_path(places(:one))
  end

  test "同じ遊び場は二重に記録されない" do
    login_as(users(:two))
    post place_visit_path(places(:one))
    assert_no_difference "Visit.count" do
      post place_visit_path(places(:one))
    end
  end

  test "「行った」記録を解除できる" do
    login_as(users(:one))
    assert_difference "Visit.count", -1 do
      delete place_visit_path(places(:one))
    end
    assert_redirected_to place_path(places(:one))
  end
end
