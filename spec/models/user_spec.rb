require 'rails_helper'

RSpec.describe  "ユーザー関連" do

  describe "ユーザー登録のテスト" do
    it "nameが空ならバリデーションが通らない" do
      user = User.new(name: "", email: "sample@example.com", password: "0000000")
      expect(user).not_to be_valid
    end
    it "emailが空ならバリデーションが通らない" do
      user = User.new(name: "sample", email: "", password: "0000000")
      expect(user).not_to be_valid
    end
    it "emailが既に登録済みの場合、バリデーションが通らない" do
      FactoryBot.create(:user)
      user = User.new(name: "sample_2", email: "sample@example.com", password: "0000000")
      expect(user).not_to be_valid
    end
    it "emailの入力形式が適切でない場合、バリデーションが通らない" do
      user = User.new(name: "sample", email: "aaaaaaaa", password: "0000000")
      expect(user).not_to be_valid
    end
    it "passwordが空ならバリデーションが通らない" do
      user = User.new(name: "sample", email: "sample@example.com", password: "")
      expect(user).not_to be_valid
    end
    it "passwordが6文字未満ならバリデーションが通らない" do
      user = User.new(name: "sample", email: "sample@example.com", password: "aaaaa")
      expect(user).not_to be_valid
    end
  end
end