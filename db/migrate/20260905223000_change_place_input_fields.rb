class ChangePlaceInputFields < ActiveRecord::Migration[7.1]
  def change
    remove_column :places, :price, :string
    remove_column :places, :business_hours, :string
    add_column :places, :adult_price, :integer                        
    add_column :places, :child_price, :integer
    add_column :places, :opening_time, :string
    add_column :places, :closing_time, :string
  end
end