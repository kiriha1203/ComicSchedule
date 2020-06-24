class AddIndexBookTitle < ActiveRecord::Migration[5.2]
  def change
    add_index :books, :title
    add_index :books, :title_kana
  end
end
