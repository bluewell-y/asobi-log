class AddReviewsCountToPlaces < ActiveRecord::Migration[7.1]
  def up
    add_column :places, :reviews_count, :integer, null: false, default: 0

    # 既存の口コミ件数を反映しておく
    Place.reset_column_information
    Place.find_each { |place| Place.reset_counters(place.id, :reviews) }
  end

  def down
    remove_column :places, :reviews_count
  end
end
