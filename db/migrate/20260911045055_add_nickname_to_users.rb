class AddNicknameToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :nickname, :string
    add_index :users, :nickname, unique: true

    # 既存ユーザーには仮のニックネームを入れておく（本人が後で変更できる）
    # name が重複しているユーザーがいても一意になるよう id を付けている
    User.reset_column_information
    User.find_each { |user| user.update_column(:nickname, "#{user.name}_#{user.id}") }

    change_column_null :users, :nickname, false
  end

  def down
    remove_column :users, :nickname
  end
end
