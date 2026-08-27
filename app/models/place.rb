class Place < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :visits, dependent: :destroy

  enum :category, {
    park: 0,             # 公園
    indoor_facility: 1,  # 室内施設
    museum: 2,           # 博物館・科学館
    aquarium_zoo: 3,     # 水族館・動物園
    other: 4             # その他
  }

  enum :indoor_outdoor, {
    indoor: 0,  # 屋内
    outdoor: 1, # 屋外
    both: 2     # 両方
  }

  validates :name, presence: true
  validates :address, presence: true

  scope :keyword_search, ->(keyword) {
    where("name ILIKE :kw OR description ILIKE :kw", kw: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
  }
  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_indoor_outdoor, ->(io) { where(indoor_outdoor: io) if io.present? }
  scope :for_age, ->(age) {
    where("(min_age IS NULL OR min_age <= :age) AND (max_age IS NULL OR max_age >= :age)", age: age) if age.present?
  }
end
