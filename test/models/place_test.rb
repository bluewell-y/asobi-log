require "test_helper"

class PlaceTest < ActiveSupport::TestCase
  def valid_place                                                                                         
    place = Place.new(
      name: "テスト公園",
      address: "東京都渋谷区1-1-1",
      user: users(:one)
    )                                                                                                     
    place.cover_image.attach(
      io: file_fixture("test_cover.png").open,
      filename: "test_cover.png",
      content_type: "image/png"
    )
    place
  end
                                                                                                          
  test "name, address, user, cover_imageがあれば保存できる" do
    assert valid_place.valid?
  end

  test "nameが空だと保存できない" do
    place = valid_place
    place.name = ""
    assert_not place.valid?
    assert place.errors.of_kind?(:name, :blank)
  end

  test "addressが空だと保存できない" do                                                                   
    place = valid_place
    place.address = ""
    assert_not place.valid?
    assert place.errors.of_kind?(:address, :blank)
  end

  test "cover_imageが無いと保存できない" do
    place = Place.new(name: "テスト公園", address: "東京都渋谷区1-1-1", user: users(:one))
    assert_not place.valid?                                                                               
    assert place.errors.of_kind?(:cover_image, :blank)
  end

  test "userが無いと保存できない" do
    place = valid_place
    place.user = nil                                                                                      
    assert_not place.valid?
  end
end