class CreateVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :visits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true
      t.date :visited_on

      t.timestamps
    end

    add_index :visits, [:user_id, :place_id], unique: true
  end
end
