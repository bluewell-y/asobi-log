class AddMoreTagsToTags < ActiveRecord::Migration[7.1]
  TAG_NAMES = ["離乳食の販売あり", "離乳食持ち込みOK", "電子レンジあり", "キッズスペースあり", "キャッシュレス対応"].freeze

  def up
    TAG_NAMES.each { |name| Tag.find_or_create_by!(name: name) }
  end

  def down
    Tag.where(name: TAG_NAMES).destroy_all
  end
end
