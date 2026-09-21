class User < ApplicationRecord
  AGE_GROUP_LABELS = {
    "teens" => "10代",
    "twenties" => "20代",
    "thirties" => "30代",
    "forties" => "40代",
    "fifties" => "50代",
    "sixties" => "60代",
    "seventies_plus" => "70代以上"
  }.freeze

  GENDER_LABELS = {
    "male" => "男性",
    "female" => "女性",
    "other" => "その他"
  }.freeze

  # 子どもの人数の上限（この値は「5人以上」として扱う）
  MAX_CHILDREN_COUNT = 5

  has_secure_password

  has_many :places, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_places, through: :favorites, source: :place
  has_many :visits, dependent: :destroy
  has_many :visited_places, through: :visits, source: :place
  has_many :reviews, dependent: :destroy
  has_many :visit_logs, dependent: :destroy
  has_many :deletion_requests, dependent: :destroy

  enum :age_group, {
    teens: 0,          # 10代
    twenties: 1,       # 20代
    thirties: 2,       # 30代
    forties: 3,        # 40代
    fifties: 4,        # 50代
    sixties: 5,        # 60代
    seventies_plus: 6  # 70代以上
  }

  enum :gender, {
    male: 0,   # 男性
    female: 1, # 女性
    other: 2   # その他
  }

  validates :name, presence: true
  validates :nickname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :age_group, presence: true
  validates :gender, presence: true
  validates :children_count, numericality: {only_integer: true, in: 0..MAX_CHILDREN_COUNT}, allow_nil: true

  def age_group_label
    AGE_GROUP_LABELS[age_group]
  end

  def gender_label
    GENDER_LABELS[gender]
  end

  # 「5人以上」は5として保存しているので、表示の時だけ「以上」をつける
  def self.children_count_text(count)
    (count >= MAX_CHILDREN_COUNT) ? "#{count}人以上" : "#{count}人"
  end

  # 入力フォームのプルダウン用（[["0人", 0], ["1人", 1], ... ["5人以上", 5]]）
  def self.children_count_options
    (0..MAX_CHILDREN_COUNT).map { |count| [children_count_text(count), count] }
  end

  def children_count_label
    self.class.children_count_text(children_count) unless children_count.nil?
  end
end
