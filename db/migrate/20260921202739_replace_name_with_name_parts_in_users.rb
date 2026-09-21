class ReplaceNameWithNamePartsInUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name_kana, :string
    add_column :users, :first_name_kana, :string

    # 旧nameは削除する。default: ""は、万一rollbackした時にNOT NULLで戻せるようにするため
    remove_column :users, :name, :string, null: false, default: ""
  end
end
