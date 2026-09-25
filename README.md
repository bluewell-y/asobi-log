# あそびログ

「今日、どこ行く？」に、もう迷わない。子どもとのお出かけ先を探して、記録するアプリです。

## 目次

- [開発背景・解決したい課題](#開発背景解決したい課題)
- [ターゲットユーザー](#ターゲットユーザー)
- [主な機能](#主な機能)
- [使用技術](#使用技術)
- [ER図](#er図)
- [テーブル設計](#テーブル設計)
- [画面一覧](#画面一覧)
- [画面遷移図](#画面遷移図)
- [セットアップ方法](#セットアップ方法)
- [工夫した点](#工夫した点)
- [苦労した点・学んだこと](#苦労した点学んだこと)
- [今後追加したい機能](#今後追加したい機能)
- [URL](#url)
- [動作確認用アカウント](#動作確認用アカウント)

---

## 開発背景・解決したい課題

休日、子どもをどこへ連れて行くか考えるのに毎回時間がかかる——という身近な悩みを解決するために開発しました。

具体的には、以下のような課題があります。

- 子どもの年齢に合う遊び場を探すのに時間がかかる
- 屋内か屋外か、料金がいくらかが事前に分かりにくい
- 一度行った場所を忘れてしまい、「また行きたい場所」を管理できていない

「あそびログ」では、条件検索・お気に入り登録・訪問記録の3つの機能でこれらを解決します。

## ターゲットユーザー

未就学児〜小学校低学年の子どもを持つ保護者。特に、休日の外出先選びに時間を取られている家庭を想定しています。

## 主な機能

| 機能 | 内容 |
|---|---|
| 会員登録・ログイン・ログアウト | `bcrypt`によるパスワードのハッシュ化、`session`によるログイン状態の管理 |
| プロフィール | 氏名（姓・名・フリガナ）、ニックネーム、年代、性別、子どもの人数を登録。年代・性別・子どもの人数はユーザー公開ページにも表示 |
| 遊び場のCRUD | 一覧・詳細の閲覧、登録・編集はログインユーザーなら誰でも可能。削除は運営管理者の承認制（下記参照） |
| 検索・絞り込み | キーワード（名前・説明文）、カテゴリ、屋内/屋外、対象年齢、都道府県/市区町村、駐車場、設備タグでの絞り込み。複数条件の組み合わせに対応 |
| 設備タグ | 「ベビーカーOK」「授乳室あり」などのタグを複数登録・絞り込みに利用できる |
| お気に入り機能 | 気になる遊び場をお気に入り登録し、一覧で確認できる |
| 「行った」記録 | 実際に訪問した遊び場を記録し、一覧で振り返れる |
| 訪問記録（日記） | 同じ遊び場に複数回、天気・満足度・同行者・メモ・写真（最大3枚）付きで記録できる |
| 口コミ機能 | 星評価とコメントを投稿。低評価（星2つ以下）はコメント必須 |
| 遊び場削除の承認フロー | 削除は即時実行せず、ログインユーザーが理由を添えて申請し、運営管理者が承認（削除実行）・却下できる |
| ユーザー公開ページ | ニックネーム・登録した遊び場・投稿した口コミ・年代/性別/子どもの人数（入力時のみ）を公開するプロフィールページ |
| OGP画像＋SNSシェア | 遊び場詳細ページにOGPタグを設定し、X・LINEへのシェアボタンを設置 |
| マイページ | 件数サマリー・自分が登録した遊び場一覧の表示、プロフィール編集、退会 |
| Basic認証 | 本番環境全体をID・パスワードで保護（開発途中のため） |
| N+1クエリ対策 | Bulletによる検出、Active Storageの画像取得は誤検知として除外設定 |
| 自動テスト | Minitestによるモデル・コントローラーのテストに加え、Capybara+Seleniumを使ったSystem Test（実ブラウザでの結合テスト） |

## 使用技術

- Ruby 3.2.0
- Ruby on Rails 7.1.6
- PostgreSQL 14
- bcrypt（パスワードのハッシュ化）
- Turbo / Stimulus（Rails標準のHotwire構成）
- Active Storage / ImageMagick（image_processing, mini_magick）（画像アップロード・リサイズ）
- Bullet（N+1クエリの検出）
- Capybara / Selenium WebDriver（System Testでの実ブラウザ操作）
- Git / GitHub（機能ごとのブランチ・Pull Requestによる開発）
- Render（本番デプロイ先）
- AWS（Render安定稼働後に移行予定）

## ER図

![ER図](docs/images/er-diagram.png)

編集用のソースは [`docs/images/er-diagram.drawio`](docs/images/er-diagram.drawio)（Draw.io / diagrams.net）です。

## テーブル設計

### users

| カラム名 | 型 | NOT NULL | デフォルト | 備考 |
|---|---|---|---|---|
| id | bigint | ○ | - | 主キー |
| last_name / first_name | string | - | - | 姓・名（ひらがな・カタカナ・漢字のみ） |
| last_name_kana / first_name_kana | string | - | - | セイ・メイ（全角カタカナのみ） |
| nickname | string | ○ | - | 遊び場の登録者名・口コミの投稿者名として表示。一意制約あり |
| email | string | ○ | - | 一意制約あり |
| password_digest | string | ○ | - | `has_secure_password`によりハッシュ化して保存 |
| age_group | integer | - | - | 年代のenum（teens 〜 seventies_plus） |
| gender | integer | - | - | 性別のenum（male / female / other） |
| children_count | integer | - | - | 子どもの人数（0〜5、5は「5人以上」） |
| admin | boolean | ○ | false | 運営管理者かどうか |

### places

| カラム名 | 型 | NOT NULL | デフォルト | 備考 |
|---|---|---|---|---|
| id | bigint | ○ | - | 主キー |
| name | string | ○ | - | 遊び場名 |
| description | text | - | - | 説明 |
| prefecture / city | string | ○ | - | 都道府県・市区町村 |
| address | string | ○ | - | 番地・建物名など |
| category | integer | ○ | 0 | enum（park / indoor_facility / museum / aquarium_zoo / other） |
| indoor_outdoor | integer | ○ | 0 | enum（indoor / outdoor / both） |
| parking | integer | ○ | 0 | enum（unavailable / available） |
| min_age / max_age | integer | - | - | 対象年齢の下限・上限 |
| adult_price / child_price | integer | - | - | 大人・子供料金 |
| opening_time / closing_time | string | - | - | 営業時間の開始・終了 |
| reviews_count | integer | ○ | 0 | 口コミ件数のカウンターキャッシュ |
| user_id | bigint | ○ | - | 外部キー（登録したユーザー） |

トップ画像・参考画像は、カラムではなくActive Storageで管理しています（`has_one_attached :cover_image` / `has_many_attached :sub_images`）。

### favorites（中間テーブル）

| カラム名 | 型 | NOT NULL | 備考 |
|---|---|---|---|
| id | bigint | ○ | 主キー |
| user_id | bigint | ○ | 外部キー |
| place_id | bigint | ○ | 外部キー |

`[user_id, place_id]`に一意制約を設定し、同じ場所への重複お気に入り登録を防止しています。

### visits（中間テーブル）

| カラム名 | 型 | NOT NULL | 備考 |
|---|---|---|---|
| id | bigint | ○ | 主キー |
| user_id | bigint | ○ | 外部キー |
| place_id | bigint | ○ | 外部キー |
| visited_on | date | - | 訪問日 |

`favorites`と同様に`[user_id, place_id]`に一意制約を設定しています。

### tags

| カラム名 | 型 | NOT NULL | 備考 |
|---|---|---|---|
| id | bigint | ○ | 主キー |
| name | string | ○ | タグ名。一意制約あり |

### place_tags（中間テーブル）

| カラム名 | 型 | NOT NULL | 備考 |
|---|---|---|---|
| id | bigint | ○ | 主キー |
| place_id | bigint | ○ | 外部キー |
| tag_id | bigint | ○ | 外部キー |

`[place_id, tag_id]`に一意制約を設定しています。

### reviews（口コミ）

| カラム名 | 型 | NOT NULL | 備考 |
|---|---|---|---|
| id | bigint | ○ | 主キー |
| user_id | bigint | ○ | 外部キー（投稿者） |
| place_id | bigint | ○ | 外部キー |
| rating | integer | ○ | 評価（0〜5の6段階。0は「星なし」） |
| comment | text | - | コメント。評価が星2つ以下の場合は必須 |

### visit_logs（訪問記録）

| カラム名 | 型 | NOT NULL | 備考 |
|---|---|---|---|
| id | bigint | ○ | 主キー |
| user_id | bigint | ○ | 外部キー |
| place_id | bigint | ○ | 外部キー |
| visited_on | date | ○ | 訪問日 |
| weather | integer | ○ | 天気のenum（sunny / cloudy / rainy） |
| satisfaction | integer | ○ | 満足度のenum（excellent 〜 bad の5段階） |
| companion | string | - | 同行者 |
| memo | text | - | メモ |

写真は、カラムではなくActive Storageで管理しています（`has_many_attached :photos`、最大3枚まで）。同じユーザー・同じ遊び場でも複数回記録できます。

### deletion_requests（遊び場の削除申請）

| カラム名 | 型 | NOT NULL | デフォルト | 備考 |
|---|---|---|---|---|
| id | bigint | ○ | - | 主キー |
| place_id | bigint | ○ | - | 外部キー |
| user_id | bigint | ○ | - | 外部キー（申請者） |
| reason | text | ○ | - | 削除理由 |
| status | integer | ○ | 0 | enum（pending / approved / rejected） |

同じ遊び場に対して、承認待ち（pending）の申請は同時に1件までに制限しています。

### アソシエーション概要

- `User has_many :places` / `:favorites` / `:visits` / `:reviews` / `:visit_logs` / `:deletion_requests`
- `User has_many :favorite_places, through: :favorites` / `has_many :visited_places, through: :visits`（お気に入り・訪問記録を通じて、それぞれ複数の遊び場と多対多）
- `Place belongs_to :user`
- `Place has_many :favorites` / `:visits` / `:reviews` / `:visit_logs` / `:deletion_requests` / `:place_tags`
- `Place has_many :tags, through: :place_tags`（設備タグと多対多）
- `Tag has_many :places, through: :place_tags`
- `Review belongs_to :user` / `belongs_to :place`（`place`は`counter_cache: true`で`places.reviews_count`を自動更新）
- `VisitLog belongs_to :user` / `belongs_to :place`
- `DeletionRequest belongs_to :user` / `belongs_to :place`

## 画面一覧

| No. | 画面 | 概要 |
|---|---|---|
| 1 | 遊び場一覧（トップページ） | 検索フォーム＋一覧表示。お気に入り/行った済みマークを表示 |
| 2 | 遊び場詳細 | 詳細情報、お気に入り/「行った」/訪問記録ボタン、口コミ一覧、シェアボタン、編集・削除申請リンク |
| 3 | 遊び場登録・編集 | ログインユーザーなら誰でもアクセス可 |
| 4 | 新規登録 | 会員登録フォーム（氏名・フリガナ・ニックネーム・年代・性別・子どもの人数） |
| 5 | ログイン | ログインフォーム |
| 6 | お気に入り一覧 | ログイン中のユーザーがお気に入り登録した遊び場の一覧 |
| 7 | 行った場所一覧 | ログイン中のユーザーが「行った」記録をした遊び場の一覧 |
| 8 | 訪問記録の新規作成・編集 | 訪問日・天気・満足度・同行者・メモ・写真を記録 |
| 9 | 場所ごとの訪問記録一覧 | 特定の遊び場について、自分が記録した訪問記録の一覧 |
| 10 | 口コミの新規作成・編集 | 星評価・コメントを投稿 |
| 11 | 自分の口コミ一覧 | 場所をまたいだ、自分が投稿した口コミの一覧 |
| 12 | 削除申請フォーム | 遊び場の削除を、理由を添えて申請 |
| 13 | 管理者用の削除申請一覧 | 運営管理者のみアクセス可。申請の承認・却下 |
| 14 | ユーザー公開ページ | ニックネーム・登録した遊び場・口コミ・年代/性別/子どもの人数（入力時のみ）を公開 |
| 15 | マイページ | 件数サマリー・自分が登録した遊び場一覧 |
| 16 | プロフィール編集 | 氏名・フリガナ・ニックネーム・年代・性別・子どもの人数・メール・パスワードの変更、退会 |

## 画面遷移図

![画面遷移図](docs/images/screen-flow.png)

編集用のソースは [`docs/images/screen-flow.drawio`](docs/images/screen-flow.drawio)（Draw.io / diagrams.net）です。

## セットアップ方法

```bash
# リポジトリをクローン
git clone https://github.com/bluewell-y/asobi-log.git
cd asobi-log

# gemをインストール
bundle install

# データベースを作成・マイグレーション
bin/rails db:create
bin/rails db:migrate

# サーバーを起動
bin/rails server
```

`http://localhost:3000` にアクセスして動作を確認できます。事前にPostgreSQLがローカルで起動している必要があります（`brew services start postgresql@14` など）。

画像のアップロード・リサイズにImageMagickを使用しているため、ローカルにインストールされていない場合は別途インストールが必要です（`brew install imagemagick` など）。

System Test（実ブラウザでの結合テスト）を実行する場合は、Google Chromeがローカルにインストールされている必要があります。
```bash
bin/rails test:system

## 工夫した点

- パスワードは`has_secure_password`（bcrypt）でハッシュ化し、平文で保存しないようにしています。
- 遊び場の編集・削除は「ログイン必須」に加え「登録者本人のみ」に制限し、`before_action`による権限チェック（`require_login` / `require_owner`）を実装しています。
- 検索・絞り込みは`scope`を使って条件ごとに分割し、自由に組み合わせて絞り込めるようにしています（キーワード・カテゴリ・屋内外・対象年齢）。
- カテゴリ・屋内外は`enum`で管理しつつ、表示用に`category_label`/`indoor_outdoor_label`メソッドを用意し、DB上は数値・コード上は名前・画面上は日本語、と役割を分離しています。
- プロフィール更新・退会は`current_user`のみを対象にし、URLのIDに依存しない実装にすることで、他人のアカウントを誤って操作できないようにしています。
- 開発途中の本番環境をBasic認証で保護し、機能が揃う前に検索エンジンや第三者に見られないようにしています。

## 苦労した点・学んだこと

- 開発の初期段階でmainブランチに直接コミットを重ねてしまい、機能単位で履歴を追いにくくなりました。途中で環境・リポジトリを作り直し、機能ごとにブランチを切ってPull Requestでマージする運用に切り替えました。
- Railsのルーティングで`resource`（単数形）と`resources`（複数形）を書き間違え、`No route matches ... missing required keys: [:id]`のようなエラーに複数回遭遇しました。単数リソース（ログインやお気に入りのトグルなど、IDを持たない操作）には`resource`を使う、という使い分けを実践を通じて身につけました。
- Renderのデプロイ設定で、Start Commandのデフォルトが`RAILS_ENV`未設定時にdevelopmentモードで起動してしまう内容だったため、本番用に明示的に`-e production`を指定し、マイグレーションも起動前に実行するよう修正しました。
- Rails 7.1とminitest 6系の間に互換性の問題があり、`bin/rails test`実行時にエラーが出ました。Gemfileでminitestを5系に固定することで解決しました。
- テスト実行時、Rails生成時のデフォルトfixtureが後から追加した制約（emailの一意性、user_idの必須化）に対応しておらず、エラーになりました。DB制約を追加した際は関連するテストデータも見直す必要があると学びました。
- CSSの詳細度（specificity）でハマりました。クラス名だけの指定（`.search-field-keyword`）よりも「要素名＋属性」の指定（`input[type="text"]`）の方が優先度が高いというルールを知らず、スタイルを上書きできない原因の切り分けに時間がかかりました。親クラスを重ねて指定する（`.search-form .search-field-keyword`）ことで、確実に優先度を上回れると学びました。
- Flexboxで、子要素に`width: 100%`を指定しても、親のflexアイテム自体の幅が不定だとパーセント指定が計算できず効かない、という仕様にも遭遇しました。`max-width`ではなく`width`を直接指定することで解決しました。
- System Test（Capybara + Selenium）で、Turbo（Hotwire）によるフォーム送信・リンク遷移は非同期に行われるため、クリック直後に次の操作を行うと画面遷移の完了を待たずに実行され、失敗することがありました。`assert_text`など「表示されるまで待つ」アサーションを遷移の直後に挟むことで解決しました。
- BulletというN+1検出gemが、Active Storageの画像取得を誤って「不要な先読み」と警告することがありました。実際には必要な先読みだったため、コードを直さずBulletの除外リスト（safelist）に登録する対応を取りました。
- 本番（Render）のデータベースはローカルのdevelopment DBとは別物で、Renderの無料プランではShell機能が使えないため、直接確認・修正するにはPostgreSQLへの外部接続（psql）が必要だと学びました。

## 今後追加したい機能

- System TestのCI（GitHub Actions）への組み込み
- 管理者権限の画面からの付与（現在はデータベースを直接操作する運用）
- SNSログイン連携
- お気に入り登録した遊び場の情報が更新された時の通知機能
- 遊び場によっては、サイトから予約・チケット購入ができる機能（クレジットカード決済に対応）
- 日付・子ども（大人）の年齢・人数を入力すると、天気や交通状況を予測して遊び場を提案してくれる機能

## URL

- 本番環境（Basic認証あり）：https://asobi-log.onrender.com
- リポジトリ：https://github.com/bluewell-y/asobi-log

## 動作確認用アカウント

本番環境は開発中のため、サイト全体をBasic認証で保護しています。以下の情報でアクセス・ログインできます。

### Basic認証（サイトを開く際に表示されるダイアログ）

| 項目 | 値 |
|---|---|
| ユーザー名 | `admin` |
| パスワード | `1111` |

### ログイン用アカウント

| 項目 | 値 |
|---|---|
| メールアドレス | `test@example.com` |
| パスワード | `password123` |

新規登録から任意のアカウントを作成することもできます。
