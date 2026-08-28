require "test_helper"

class UserTest < ActiveSupport::TestCase
  def valid_user
    User.new(
      name: "テストユーザー",
      email: "unique_test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "name, email, passwordがあれば保存できる" do
    assert valid_user.valid?
  end

  test "nameが空だと保存できない" do
    user = valid_user
    user.name = ""
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "emailが重複していると保存できない" do
    valid_user.save!
    duplicate = valid_user
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
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
end