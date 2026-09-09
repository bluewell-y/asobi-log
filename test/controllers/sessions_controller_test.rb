require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "ログイン画面を表示できる" do
    get new_session_path
    assert_response :success
  end

  test "正しい認証情報でログインでき、トップへリダイレクトする" do
    post session_path, params: {email: users(:one).email, password: "password123"}
    assert_redirected_to root_path
    assert_equal users(:one).id, session[:user_id]
  end

  test "誤った認証情報ではログインできず、422を返す" do
    post session_path, params: {email: users(:one).email, password: "wrong"}
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "ログアウトするとセッションが消え、トップへリダイレクトする" do
    login_as(users(:one))
    delete session_path
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
