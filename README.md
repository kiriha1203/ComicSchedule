# README

# Job_Searcher

# 概要

漫画の発売する日より指定した日数より前日に自動でメールを送ってくれるサービスです。
楽天Bookからスクレイピングにより漫画の発売日などを入手し、DBに登録。
ユーザーがメールを送って欲しい漫画をお気に入り登録することで自動で配信されます。

# コンセプト

ベルアラートを参考に制作。

# バージョン

Ruby 2.6.5
Ruby On Rails 5.2.4
PostgreSQL 12.2

# 使用予定Gem
* devise
* devise-i18n
* devose-i18n-views
* letter_opener_web
* dotenv-rails
* pry-rails
* better_errors
* ransack
* kaminari
* acts-as-taggable-on
* rspec_rails
* factory_bot_rails
* faker
* webdrivers
* capybara
* database-cleaner
* omniauth-google-oauth2
* enum_help
* select2-rails
* whenever


# 機能一覧
* ユーザー機能
    * サインイン機能
    * サインアップ機能
    * ユーザー一覧表示(adminのみ)
    * ユーザー情報詳細表示機能
    * ユーザー情報更新機能
    * ユーザー削除機能（退会）
    * ユーザー削除機能(adminのみ)
    
* book機能
    * dbへスクレイピンングから正規表現で取り出し、登録させる
    * book一覧表示
    * book情報詳細表示機能(adminのみ)
    * book情報更新機能(adminのみ)
    * book削除機能(adminのみ)
    
* book_detail機能(bookの詳細　１巻,２巻,特装版など)
    * dbへスクレイピンングから正規表現で取り出し、登録させる
    * ブログ情報詳細表示
    * ブログ更新機能(adminのみ)
    * ブログ削除機能(adminのみ)

* お気に入り機能
    * ユーザーがお気に入り登録（ブックマーク）できる
    * ユーザーがお気に入り登録（ブックマーク）削除できる
    
    
* 検索機能
    * ユーザーがアイウエオ検索ができる
    * ユーザーがlike検索ができる
    

    
# カタログ設計・テーブル定義
[リンク](https://docs.google.com/spreadsheets/d/1gcogY-u-EWBGi_my7e6AriNvzbgEhNS0ZrMH3jK93cQ/edit#gid=1816941356)

# ER図
[リンク](https://drive.google.com/file/d/1u1FAe5Jabs9Z_OAAqu87Z4OwONGtIkEP/view?usp=sharing)

# 画面遷移図
[リンク](https://drive.google.com/file/d/1_y-Ar_xEQ4dSnEHaQw2AQCxsuBvj6GG9/view?usp=sharing)

# ワイヤーフレーム
[リンク](https://drive.google.com/file/d/1_y-Ar_xEQ4dSnEHaQw2AQCxsuBvj6GG9/view?usp=sharing)