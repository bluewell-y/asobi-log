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
        nickname: "しんきち",
        email: "shinki@example.com",
        password: "password123",
        password_confirmation: "password123",
        age_group: "thirties",
        gender: "male",
        children_count: "2"
      }}
    end
    assert_redirected_to root_path
    user = User.find_by!(email: "shinki@example.com")
    assert_equal "thirties", user.age_group
    assert_equal "male", user.gender
    assert_equal 2, user.children_count
  end

  test "年代・性別が未入力だと登録できず、422を返す" do
    assert_no_difference "User.count" do
      post users_path, params: {user: {
        name: "新規太郎",
        nickname: "しんきち",
        email: "shinki@example.com",
        password: "password123",
        password_confirmation: "password123"
      }}
    end
    assert_response :unprocessable_entity
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

  test "年代・性別・子どもの人数を更新できる" do
    login_as(users(:one))
    patch mypage_path, params: {user: {age_group: "fifties", gender: "other", children_count: "3"}}
    assert_redirected_to mypage_path
    user = users(:one).reload
    assert_equal "fifties", user.age_group
    assert_equal "other", user.gender
    assert_equal 3, user.children_count
  end

  test "子どもの人数を空にして更新すると未設定に戻る" do
    users(:one).update!(children_count: 2)
    login_as(users(:one))
    patch mypage_path, params: {user: {children_count: ""}}
    assert_redirected_to mypage_path
    assert_nil users(:one).reload.children_count
  end

  test "年代・性別が未入力の既存ユーザーは、入力するまでプロフィールを更新できない" do
    users(:one).update_columns(age_group: nil, gender: nil)
    login_as(users(:one))
    patch mypage_path, params: {user: {name: "改名済み"}}
    assert_response :unprocessable_entity
    assert_not_equal "改名済み", users(:one).reload.name
  end

  test "退会するとユーザーが削除され、ログアウトする" do
    login_as(users(:one))
    assert_difference "User.count", -1 do
      delete mypage_path
    end
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end

  test "公開ページに年代・性別・子どもの人数が表示される" do
    users(:one).update!(age_group: :forties, gender: :female, children_count: 5)
    get user_path(users(:one))
    assert_response :success
    assert_includes response.body, "年代：40代"
    assert_includes response.body, "性別：女性"
    assert_includes response.body, "子どもの人数：5人以上"
  end

  test "公開ページでは、未入力の項目は表示されない" do
    users(:one).update_columns(age_group: nil, gender: nil, children_count: nil)
    get user_path(users(:one))
    assert_response :success
    assert_not_includes response.body, "年代："
    assert_not_includes response.body, "性別："
    assert_not_includes response.body, "子どもの人数："
  end
end
