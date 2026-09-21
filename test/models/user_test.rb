require "test_helper"

class UserTest < ActiveSupport::TestCase
  def valid_user
    User.new(
      last_name: "山田",
      first_name: "太郎",
      last_name_kana: "ヤマダ",
      first_name_kana: "タロウ",
      nickname: "テストにっく",
      email: "unique_test@example.com",
      password: "password123",
      password_confirmation: "password123",
      age_group: :thirties,
      gender: :female
    )
  end

  test "姓名・フリガナ, nickname, email, passwordがあれば保存できる" do
    assert valid_user.valid?
  end

  test "姓・名・セイ・メイが空だと保存できない" do
    %i[last_name first_name last_name_kana first_name_kana].each do |attr|
      user = valid_user
      user[attr] = ""
      assert_not user.valid?, "#{attr}が空でも保存できてしまった"
      assert user.errors.of_kind?(attr, :blank)
    end
  end

  test "姓・名にひらがな・カタカナ・漢字以外を入れると保存できない" do
    ["Yamada", "山田 ", "山田1", "山 田"].each do |value|
      user = valid_user
      user.last_name = value
      assert_not user.valid?, "「#{value}」は無効なはず"
    end
  end

  test "姓・名にひらがな・カタカナ・漢字・長音を入れると保存できる" do
    ["やまだ", "ヤマダ", "山田", "渡辺", "ジョー", "佐々木", "々"].each do |value|
      user = valid_user
      user.first_name = value
      assert user.valid?, "「#{value}」は有効なはず"
    end
  end

  test "セイ・メイは全角カタカナ以外だと保存できない" do
    ["やまだ", "山田", "Yamada", "ﾔﾏﾀﾞ", "ヤマ ダ"].each do |value|
      user = valid_user
      user.last_name_kana = value
      assert_not user.valid?, "「#{value}」は無効なはず"
    end
  end

  test "full_nameは姓と名をスペースでつなぐ" do
    assert_equal "山田 太郎", valid_user.full_name
  end

  test "nicknameが空だと保存できない" do
    user = valid_user
    user.nickname = ""
    assert_not user.valid?
    assert user.errors.of_kind?(:nickname, :blank)
  end

  test "nicknameが重複していると保存できない" do
    valid_user.save!
    duplicate = valid_user
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:nickname, :taken)
  end

  test "emailが重複していると保存できない" do
    valid_user.save!
    duplicate = valid_user
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:email, :taken)
  end

  test "正しいパスワードでauthenticateが成功する" do
    user = valid_user
    user.save!
    assert user.authenticate("password123")
  end

  test "間違ったパスワードでauthenticateが失敗する" do
    user = valid_user
    user.save!
    assert_not user.authenticate("wrongpassword")
  end

  test "age_groupが空だと保存できない" do
    user = valid_user
    user.age_group = nil
    assert_not user.valid?
    assert user.errors.of_kind?(:age_group, :blank)
  end

  test "genderが空だと保存できない" do
    user = valid_user
    user.gender = nil
    assert_not user.valid?
    assert user.errors.of_kind?(:gender, :blank)
  end

  test "children_countは空でも保存できる" do
    user = valid_user
    user.children_count = nil
    assert user.valid?
  end

  test "children_countは0〜5の整数なら保存できる" do
    user = valid_user
    [0, 3, 5].each do |count|
      user.children_count = count
      assert user.valid?, "#{count}人は有効なはず"
    end
  end

  test "children_countが6以上や負の数だと保存できない" do
    user = valid_user
    [6, -1].each do |count|
      user.children_count = count
      assert_not user.valid?, "#{count}人は無効なはず"
    end
  end

  test "ラベルメソッドが日本語を返す" do
    user = valid_user
    user.children_count = 5
    assert_equal "30代", user.age_group_label
    assert_equal "女性", user.gender_label
    assert_equal "5人以上", user.children_count_label
    user.children_count = 2
    assert_equal "2人", user.children_count_label
    user.children_count = nil
    assert_nil user.children_count_label
  end
end
