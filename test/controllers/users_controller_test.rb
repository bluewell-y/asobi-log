require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "新規登録画面を表示できる" do
    get new_user_path
    assert_response :success
  end

  test "有効な情報で登録でき、ログイン状態になる" do
    assert_difference "User.count", 1 do
      post users_path, params: {user: {
        name: "新規太郎",
        email: "shinki@example.com",
        password: "password123",
        password_confirmation: "password123"
      }}
    end
    assert_redirected_to root_path
    assert User.exists?(email: "shinki@example.com")
  end

  test "無効な情報では登録できず、422を返す" do
    assert_no_difference "User.count" do
      post users_path, params: {user: {name: "", email: "", password: "", password_confirmation: ""}}
    end
    assert_response :unprocessable_entity
  end

  test "未ログインでマイページを開くとログイン画面へリダイレクトする" do
    get mypage_path
    assert_redirected_to new_session_path
  end

  test "ログイン中はマイページを表示できる" do
    login_as(users(:one))
    get mypage_path
    assert_response :success
  end

  test "プロフィールを更新できる" do
    login_as(users(:one))
    patch mypage_path, params: {user: {name: "改名済み"}}
    assert_redirected_to mypage_path
    assert_equal "改名済み", users(:one).reload.name
  end

  test "退会するとユーザーが削除され、ログアウトする" do
    login_as(users(:one))
    assert_difference "User.count", -1 do
      delete mypage_path
    end
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
