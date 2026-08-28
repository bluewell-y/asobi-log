require "test_helper"

class PlaceTest < ActiveSupport::TestCase
  def valid_place
    Place.new(
      name: "テスト公園",
      address: "東京都渋谷区1-1-1",
      user: users(:one)
    )
  end

  test "name, address, userがあれば保存できる" do
    assert valid_place.valid?
  end

  test "nameが空だと保存できない" do
    place = valid_place
    place.name = ""
    assert_not place.valid?
    assert_includes place.errors[:name], "can't be blank"
  end

  test "addressが空だと保存できない" do
    place = valid_place
    place.address = ""
    assert_not place.valid?
    assert_includes place.errors[:address], "can't be blank"
  end

  test "userが無いと保存できない" do
    place = valid_place
    place.user = nil
    assert_not place.valid?
  end
end