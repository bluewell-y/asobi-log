class CreateDeletionRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :deletion_requests do |t|
      t.references :place, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :reason, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
