class CreateVisitLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :visit_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true
      t.date :visited_on, null: false
      t.integer :weather, null: false
      t.integer :satisfaction, null: false
      t.string :companion
      t.text :memo

      t.timestamps
    end
  end
end
