class CreateTags < ActiveRecord::Migration[7.1]
  TAG_NAMES = ["ベビーカーOK", "授乳室あり", "ミルク作り可", "オムツ替え台あり", "更衣室あり", "飲食店あり", "イートインコーナーあり"].freeze

  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :tags, :name, unique: true

    TAG_NAMES.each { |name| Tag.create!(name: name) }
  end
end
