class CreatePlaces < ActiveRecord::Migration[7.1]
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.text :description
      t.string :address, null: false
      t.integer :category, null: false, default: 0
      t.integer :indoor_outdoor, null: false, default: 0
      t.integer :min_age
      t.integer :max_age
      t.string :price
      t.string :business_hours

      t.timestamps
    end
  end
end
