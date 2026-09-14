class PlaceTag < ApplicationRecord
  belongs_to :place
  belongs_to :tag

  validates :tag_id, uniqueness: {scope: :place_id}
end
