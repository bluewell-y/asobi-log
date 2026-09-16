require "test_helper"

class DeletionRequestsControllerTest < ActionDispatch::IntegrationTest
  def create_place(owner)
    place = owner.places.build(
      name: "削除申請テスト遊び場",
      prefecture: "東京都",
      city: "渋谷区",
      address: "1-1",
      category: "park",
      indoor_outdoor: "outdoor"
    )
    place.cover_image.attach(
      io: file_fixture("test_cover.png").open,
      filename: "test_cover.png",
      content_type: "image/png"
    )
    place.save!
    place
  end

  test "ログインしていれば誰でも削除を申請できる" do
    place = create_place(users(:one))
    login_as(users(:two))
    assert_difference "DeletionRequest.count", 1 do
      post place_deletion_requests_path(place), params: {deletion_request: {reason: "閉業したため"}}
    end
    assert_redirected_to place_path(place)
  end

  test "未ログインだと申請できない" do
    place = create_place(users(:one))
    assert_no_difference "DeletionRequest.count" do
      post place_deletion_requests_path(place), params: {deletion_request: {reason: "閉業したため"}}
    end
    assert_redirected_to new_session_path
  end

  test "理由が空だと申請できない" do
    place = create_place(users(:one))
    login_as(users(:one))
    assert_no_difference "DeletionRequest.count" do
      post place_deletion_requests_path(place), params: {deletion_request: {reason: ""}}
    end
    assert_response :unprocessable_entity
  end

  test "同じ遊び場に承認待ちの申請が既にあると申請できない" do
    place = create_place(users(:one))
    login_as(users(:one))
    place.deletion_requests.create!(user: users(:one), reason: "先に出した申請")

    assert_no_difference "DeletionRequest.count" do
      post place_deletion_requests_path(place), params: {deletion_request: {reason: "後から出した申請"}}
    end
    assert_response :unprocessable_entity
  end
end
