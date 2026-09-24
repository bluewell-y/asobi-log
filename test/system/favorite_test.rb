require "application_system_test_case"

class FavoriteTest < ApplicationSystemTestCase
  test "遊び場をお気に入りに追加すると、お気に入り一覧に反映される" do
    sign_in(users(:one))
    place = places(:two)

    visit place_path(place)
    click_button "お気に入りに追加"

    assert_text "お気に入りに追加しました"
    assert_button "お気に入り解除"

    visit favorites_path
    assert_link place.name
  end
end
