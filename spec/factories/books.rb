FactoryBot.define do
  factory :book do
    id { 1 }
    title { "ああ無情" }
    title_kana { "ああむじょう" }
    author { "ヴィクトル・ユーゴー" }
    label { "青い鳥文庫" }
    issue_from { "文庫本" }
  end
  factory :second_book, class: Book do
    id { 2 }
    title { "異世界ですが魔物栽培してます。" }
    title_kana { "いせかいですがまものさいばいしてます" }
    author { "蕨野くげ子, 雪月花, ｓｈｒｉ" }
    label { "MFC" }
    issue_from { "コミック" }
  end
  factory :third_book, class: Book do
    id { 3 }
    title { "オオヤンキー！！" }
    title_kana { "おおやんんきー！！" }
    author { "蒼井ひな太" }
    label { "サンデーうぇぶりコミックス" }
    issue_from { "コミック" }
  end
end
