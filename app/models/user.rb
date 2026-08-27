class User < ApplicationRecord
  has_secure_password

  has_many :places, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_places, through: :favorites, source: :place
  has_many :visits, dependent: :destroy
  has_many :visited_places, through: :visits, source: :place
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
