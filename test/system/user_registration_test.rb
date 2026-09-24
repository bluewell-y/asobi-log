require "application_system_test_case"

class UserRegistrationTest < ApplicationSystemTestCase
  test "新規登録するとログイン状態になり、マイページを表示できる" do
    visit new_user_path

    fill_in "姓", with: "新規"
    fill_in "名", with: "太郎"
    fill_in "セイ", with: "シンキ"
    fill_in "メイ", with: "タロウ"
    fill_in "ニックネーム", with: "system_test_nickname"
    select "20代", from: "年代"
    select "男性", from: "性別"
    fill_in "メールアドレス", with: "system_test_user@example.com"
    fill_in "user_password", with: "password123"
    fill_in "user_password_confirmation", with: "password123"

    click_button "登録する"

    assert_text "会員登録が完了しました"
    assert_text "system_test_nickname"

    visit mypage_path
    assert_selector "h1", text: "マイページ"
  end
end
