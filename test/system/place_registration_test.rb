require "application_system_test_case"

class PlaceRegistrationTest < ApplicationSystemTestCase
  test "遊び場を登録すると、一覧・詳細ページに表示される" do
    sign_in(users(:one))

    visit new_place_path

    fill_in "遊び場名", with: "システムテスト公園"
    attach_file "トップ画像", Rails.root.join("test/fixtures/files/test_cover.png")
    select "東京都", from: "都道府県"
    select "渋谷区", from: "市区町村"
    fill_in "番地・建物名など", with: "1-1"
    select "公園", from: "カテゴリー"
    select "屋外", from: "屋内/屋外"
    select "あり", from: "駐車場"

    click_button "保存する"

    assert_text "遊び場を登録しました"
    assert_selector "h1", text: "システムテスト公園"

    visit places_path
    assert_link "システムテスト公園"

    click_link "システムテスト公園"
    assert_selector "h1", text: "システムテスト公園"
    assert_text "渋谷区"
  end
end
