require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  def valid_review
    Review.new(user: users(:one), place: places(:one), rating: 5, comment: "良かったです")
  end

  test "ratingとuser、placeがあれば保存できる" do
    assert valid_review.valid?
  end

  test "ratingが空だと保存できない" do
    review = valid_review
    review.rating = nil
    assert_not review.valid?
    assert review.errors.of_kind?(:rating, :blank)
  end

  test "ratingが0〜5の範囲外だと保存できない" do
    review = valid_review
    review.rating = 6
    assert_not review.valid?
    assert review.errors.of_kind?(:rating, :inclusion)
  end

  test "ratingが2以下でcommentが空だと保存できない" do
    review = valid_review
    review.rating = 2
    review.comment = ""
    assert_not review.valid?
    assert review.errors.of_kind?(:comment, :blank)
  end

  test "ratingが3以上ならcommentが空でも保存できる" do
    review = valid_review
    review.rating = 3
    review.comment = ""
    assert review.valid?
  end
end
