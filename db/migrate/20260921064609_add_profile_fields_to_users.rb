class AddProfileFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :age_group, :integer
    add_column :users, :gender, :integer
    add_column :users, :children_count, :integer
  end
end
