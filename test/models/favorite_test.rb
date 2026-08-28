require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  test "同じuserとplaceの組み合わせは重複登録できない" do
    Favorite.create!(user: users(:one), place: places(:two))
    duplicate = Favorite.new(user: users(:one), place: places(:two))

    assert_not duplicate.valid?
  end

  test "userとplaceの組み合わせが異なれば登録できる" do
    favorite = Favorite.new(user: users(:one), place: places(:two))
    assert favorite.valid?
  end
end