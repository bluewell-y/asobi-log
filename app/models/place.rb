class Place < ApplicationRecord
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
end
