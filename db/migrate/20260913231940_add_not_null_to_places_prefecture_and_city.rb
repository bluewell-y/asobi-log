class AddNotNullToPlacesPrefectureAndCity < ActiveRecord::Migration[7.1]
  def change
    change_column_null :places, :prefecture, false
    change_column_null :places, :city, false
  end
end
