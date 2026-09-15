class VisitLog < ApplicationRecord
  WEATHER_LABELS = {
    "sunny" => "晴れ",
    "cloudy" => "曇り",
    "rainy" => "雨"
  }.freeze

  SATISFACTION_LABELS = {
    "excellent" => "たいへんよい",
    "good" => "よい",
    "normal" => "ふつう",
    "poor" => "微妙",
    "bad" => "悪い"
  }.freeze

  belongs_to :user
  belongs_to :place
  has_many_attached :photos

  enum :weather, {
    sunny: 0,  # 晴れ
    cloudy: 1, # 曇り
    rainy: 2   # 雨
  }

  enum :satisfaction, {
    excellent: 0, # たいへんよい
    good: 1,      # よい
    normal: 2,    # ふつう
    poor: 3,      # 微妙
    bad: 4        # 悪い
  }

  validates :visited_on, presence: true
  validates :weather, presence: true
  validates :satisfaction, presence: true
  validate :photos_within_limit

  def weather_label
    WEATHER_LABELS[weather]
  end

  def satisfaction_label
    SATISFACTION_LABELS[satisfaction]
  end

  private

  def photos_within_limit
    errors.add(:photos, "は3枚までしか登録できません") if photos.size > 3
  end
end
