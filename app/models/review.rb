class Review < ApplicationRecord
  belongs_to :user
  belongs_to :place, counter_cache: true

  validates :rating, presence: true, inclusion: {in: 0..5}
  validates :comment, presence: true, if: :comment_required?

  # 星なし〜星2つは、低評価の理由が伝わるようコメント必須にする
  def comment_required?
    rating.present? && rating <= 2
  end
end
