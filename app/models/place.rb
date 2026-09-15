class Place < ApplicationRecord
  # 出典: geolonia/japanese-addresses（CC BY 4.0）https://github.com/geolonia/japanese-addresses
  PREFECTURES_CITIES = JSON.parse(File.read(Rails.root.join("db/data/prefectures_cities.json"))).freeze
  PREFECTURES = PREFECTURES_CITIES.keys.freeze

  CATEGORY_LABELS = {
    "park" => "公園",
    "indoor_facility" => "室内施設",
    "museum" => "博物館・科学館",
    "aquarium_zoo" => "水族館・動物園",
    "other" => "その他"
  }.freeze

  INDOOR_OUTDOOR_LABELS = {
    "indoor" => "屋内",
    "outdoor" => "屋外",
    "both" => "両方"
  }.freeze

  PARKING_LABELS = {
    "unavailable" => "なし",
    "available" => "あり"
  }.freeze

  belongs_to :user
  has_one_attached :cover_image
  has_many_attached :sub_images
  has_many :favorites, dependent: :destroy
  has_many :visits, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :place_tags, dependent: :destroy
  has_many :tags, through: :place_tags

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

  enum :parking, {
    unavailable: 0, # なし
    available: 1    # あり
  }

  validates :name, presence: true
  validates :address, presence: true
  validates :cover_image, presence: true
  validates :category, presence: true
  validates :indoor_outdoor, presence: true
  validates :prefecture, presence: true, inclusion: {in: PREFECTURES}
  validates :city, presence: true
  validate :city_belongs_to_prefecture
  validates :parking, presence: true

  scope :keyword_search, ->(keyword) {
    where("name ILIKE :kw OR description ILIKE :kw", kw: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
  }
  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_indoor_outdoor, ->(io) { where(indoor_outdoor: io) if io.present? }
  scope :by_tags, ->(tag_ids) {
    tag_ids = Array(tag_ids).reject(&:blank?)
    joins(:place_tags).where(place_tags: {tag_id: tag_ids}).distinct if tag_ids.present?
  }
  scope :for_age, ->(age) {
    where("(min_age IS NULL OR min_age <= :age) AND (max_age IS NULL OR max_age >= :age)", age: age) if age.present?
  }

  def category_label
    CATEGORY_LABELS[category]
  end

  def indoor_outdoor_label
    INDOOR_OUTDOOR_LABELS[indoor_outdoor]
  end

  def parking_label
    PARKING_LABELS[parking]
  end

  def self.cities_for(prefecture)
    PREFECTURES_CITIES.fetch(prefecture, [])
  end

  def fee_text
    parts = []
    parts << "大人 #{adult_price}円" if adult_price.present?
    parts << "子供 #{child_price}円" if child_price.present?
    parts.join("／").presence
  end

  def business_hours_text
    return nil if opening_time.blank? && closing_time.blank?

    "#{opening_time}〜#{closing_time}"
  end

  def age_range_text
    return nil if min_age.blank? && max_age.blank?

    lower = min_age.present? ? "#{min_age}歳" : ""
    upper = max_age.present? ? "#{max_age}歳" : "年齢上限なし"
    "#{lower}〜#{upper}"
  end

  def full_address
    "#{prefecture}#{city}#{address}"
  end

  private

  def city_belongs_to_prefecture
    return if prefecture.blank? || city.blank?

    unless self.class::PREFECTURES_CITIES.fetch(prefecture, []).include?(city)
      errors.add(:city, :invalid)
    end
  end
end
