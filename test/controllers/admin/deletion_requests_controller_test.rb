require "test_helper"

class Admin::DeletionRequestsControllerTest < ActionDispatch::IntegrationTest
  def create_place(owner)
    place = owner.places.build(
      name: "承認テスト遊び場",
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

  test "管理者は削除申請の一覧を見られる" do
    place = create_place(users(:one))
    deletion_request = place.deletion_requests.create!(user: users(:two), reason: "テスト理由")
    admin = users(:two)
    admin.update!(admin: true)
    login_as(admin)

    get admin_deletion_requests_path
    assert_response :success
    assert_includes response.body, deletion_request.reason
  end

  test "管理者以外は一覧を見られない" do
    login_as(users(:one))
    get admin_deletion_requests_path
    assert_redirected_to root_path
  end

  test "未ログインだと一覧を見られない" do
    get admin_deletion_requests_path
    assert_redirected_to new_session_path
  end

  test "承認すると遊び場と申請ごと削除される" do
    place = create_place(users(:one))
    deletion_request = place.deletion_requests.create!(user: users(:two), reason: "テスト理由")
    admin = users(:two)
    admin.update!(admin: true)
    login_as(admin)

    assert_difference "Place.count", -1 do
      patch approve_admin_deletion_request_path(deletion_request)
    end
    assert_redirected_to admin_deletion_requests_path
  end

  test "却下すると申請はrejectedになり遊び場は残る" do
    place = create_place(users(:one))
    deletion_request = place.deletion_requests.create!(user: users(:two), reason: "テスト理由")
    admin = users(:two)
    admin.update!(admin: true)
    login_as(admin)

    assert_no_difference "Place.count" do
      patch reject_admin_deletion_request_path(deletion_request)
    end
    assert_equal "rejected", deletion_request.reload.status
    assert_redirected_to admin_deletion_requests_path
  end
end
