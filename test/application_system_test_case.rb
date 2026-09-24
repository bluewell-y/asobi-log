require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # System Testはブラウザを複数同時に立ち上げると重くなり不安定になるので、並列実行しない
  parallelize(workers: 1)

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  # ページ遷移待ちのタイムアウトを少し伸ばす（デフォルトは2秒）
  Capybara.default_max_wait_time = 5

  # フィクスチャのユーザーで、実際にログイン画面から操作してログインする
  def sign_in(user, password: "password123")
    visit new_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: password
    click_button "ログイン"
    assert_text "ログインしました"
  end
end
