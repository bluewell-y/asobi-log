class AddReviewsCountToPlaces < ActiveRecord::Migration[7.1]
  class MigrationPlace < ApplicationRecord
    self.table_name = "places"
  end

  def up
    add_column :places, :reviews_count, :integer, null: false, default: 0

    # 既存の口コミ件数を反映しておく
    MigrationPlace.reset_column_information
    MigrationPlace.find_each { |place| MigrationPlace.reset_counters(place.id, :reviews) }
  end

  def down
    remove_column :places, :reviews_count
  end
end
