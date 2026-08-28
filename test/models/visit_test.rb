require "test_helper"

class VisitTest < ActiveSupport::TestCase
  test "同じuserとplaceの組み合わせは重複登録できない" do
    Visit.create!(user: users(:one), place: places(:two))
    duplicate = Visit.new(user: users(:one), place: places(:two))

    assert_not duplicate.valid?
  end

  test "userとplaceの組み合わせが異なれば登録できる" do
    visit = Visit.new(user: users(:one), place: places(:two))
    assert visit.valid?
  end
end