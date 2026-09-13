class AddParkingToPlaces < ActiveRecord::Migration[7.1]
  def change
    add_column :places, :parking, :integer, null: false, default: 0
  end
end
