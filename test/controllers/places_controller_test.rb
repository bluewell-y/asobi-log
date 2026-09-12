require "test_helper"

class PlacesControllerTest < ActionDispatch::IntegrationTest
  # cover_image が必須なので、更新・削除・所有者判定のテストでは
  # 画像付きの有効な Place をその場で作る
  def create_place(owner)
    place = owner.places.build(
      name: "所有テスト遊び場",
      address: "東京都テスト区1-1",
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

  def cover_upload
    Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/test_cover.png"), "image/png")
  end

  test "一覧はログインなしで表示できる" do
    get places_path
    assert_response :success
  end

  test "詳細はログインなしで表示できる" do
    get place_path(places(:one))
    assert_response :success
  end

  test "キーワードで絞り込める" do
    get places_path, params: {keyword: places(:one).name}
    assert_response :success
    assert_includes response.body, places(:one).name
  end

  test "未ログインで新規作成画面を開くとログイン画面へリダイレクトする" do
    get new_place_path
    assert_redirected_to new_session_path
  end

  test "ログイン中は新規作成画面を表示できる" do
    login_as(users(:one))
    get new_place_path
    assert_response :success
  end

  test "有効な情報で遊び場を登録できる" do
    login_as(users(:one))
    assert_difference "Place.count", 1 do
      post places_path, params: {place: {
        name: "新しい遊び場",
        address: "東京都新宿区2-2",
        category: "museum",
        indoor_outdoor: "indoor",
        cover_image: cover_upload
      }}
    end
    assert_redirected_to place_path(Place.last)
    assert_equal users(:one).id, Place.last.user_id
  end

  test "トップ画像なしでは登録できず、422を返す" do
    login_as(users(:one))
    assert_no_difference "Place.count" do
      post places_path, params: {place: {
        name: "画像なし", address: "住所", category: "park", indoor_outdoor: "outdoor"
      }}
    end
    assert_response :unprocessable_entity
  end

  test "登録者本人は編集画面を開ける" do
    place = create_place(users(:one))
    login_as(users(:one))
    get edit_place_path(place)
    assert_response :success
  end

  test "登録者以外でもログインしていれば編集画面を開ける" do
    place = create_place(users(:one))
    login_as(users(:two))
    get edit_place_path(place)
    assert_response :success
  end

  test "未ログインで編集画面を開くとログイン画面へリダイレクトする" do
    place = create_place(users(:one))
    get edit_place_path(place)
    assert_redirected_to new_session_path
  end

  test "登録者本人は遊び場を更新できる" do
    place = create_place(users(:one))
    login_as(users(:one))
    patch place_path(place), params: {place: {name: "更新後の名前"}}
    assert_redirected_to place_path(place)
    assert_equal "更新後の名前", place.reload.name
  end

  test "登録者以外でもログインしていれば更新できる" do
    place = create_place(users(:one))
    login_as(users(:two))
    patch place_path(place), params: {place: {name: "他人が更新した名前"}}
    assert_redirected_to place_path(place)
    assert_equal "他人が更新した名前", place.reload.name
  end

  test "登録者本人は遊び場を削除できる" do
    place = create_place(users(:one))
    login_as(users(:one))
    assert_difference "Place.count", -1 do
      delete place_path(place)
    end
    assert_redirected_to places_path
  end

  test "登録者以外は削除できない" do
    place = create_place(users(:one))
    login_as(users(:two))
    assert_no_difference "Place.count" do
      delete place_path(place)
    end
    assert_redirected_to places_path
  end

  test "未ログインで削除しようとするとログイン画面へリダイレクトする" do
    place = create_place(users(:one))
    assert_no_difference "Place.count" do
      delete place_path(place)
    end
    assert_redirected_to new_session_path
  end

  test "APIキーがあれば詳細ページに地図が表示される" do
    original = ENV["GOOGLE_MAPS_API_KEY"]
    ENV["GOOGLE_MAPS_API_KEY"] = "test-key"
    get place_path(places(:one))
    assert_includes response.body, "https://www.google.com/maps/embed/v1/place"
  ensure
    ENV["GOOGLE_MAPS_API_KEY"] = original
  end
end
