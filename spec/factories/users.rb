
FactoryBot.define do
  factory :user do
    id { 1 }
    name { "sample" }
    email { "sample@example.com" }
    password { "password" }
    sex { 1 }
    birthday { Date.new(1990, 1, 1) }
    notification { 1 }
    admin { false }
  end
  factory :second_user, class: User do
    id { 2 }
    name { "second_user" }
    email { "user@example.com" }
    password { "password" }
    sex { 1 }
    birthday { Date.new(1990, 1, 1) }
    notification { 2 }
    admin { false }
  end
  factory :admin_user, class: User do
    id { 3 }
    name { "admin_user" }
    email { "admin@example.com" }
    password { "0000000" }
    sex { 1 }
    birthday { Date.new(1990, 1, 1) }
    notification { 3 }
    admin { true }
  end
end