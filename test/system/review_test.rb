require "application_system_test_case"

class ReviewTest < ApplicationSystemTestCase
  test "口コミを投稿すると、詳細ページに反映される" do
    sign_in(users(:one))
    place = places(:two)

    visit place_path(place)
    click_link "口コミを投稿する"
    assert_selector "h1", text: "口コミを投稿する"

    choose "★★★★★"
    fill_in "コメント", with: "システムテストからの口コミです"

    click_button "投稿する"

    assert_text "口コミを投稿しました"
    assert_text "システムテストからの口コミです"
    assert_text "★★★★★"
  end
end
