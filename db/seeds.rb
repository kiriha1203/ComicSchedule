User.create!(name:  "管理者",
             email: "admin@example",
             password:  "password",
             password_confirmation: "password",
             admin: true,
             sex: 1,
             birthday: "2001-01-01",
             notification: 1)

User.create!(name:  "test",
             email: "test@example",
             password:  "password",
             password_confirmation: "password",
             sex: 0,
             birthday: "2001-01-01",
             notification: 2)

Book.create!(title: "ああ無情",
             title_kana: "ああむじょう",
             author: "‎ヴィクトル・ユーゴー",
             label: "青い鳥文庫",
             issue_from: "コミック")

Book.create!(title: "アムリタ",
             title_kana: "あむりた",
             author: "‎野崎まど",
             label: "メディアワークス文庫",
             issue_from: "小説")

Book.create!(title: "羅生門",
             title_kana: "らしょうもん",
             author: "芥川龍之介",
             label: "青空文庫",
             issue_from: "小説")

Book.create!(title: "居合",
             title_kana: "いあい",
             author: "芥川龍之介",
             label: "青空文庫",
             issue_from: "小説")
