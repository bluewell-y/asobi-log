class Tag < ApplicationRecord
  has_many :place_tags, dependent: :destroy
  has_many :places, through: :place_tags

  validates :name, presence: true, uniqueness: true
end
