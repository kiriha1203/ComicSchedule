class CreateBookDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :book_details do |t|
      t.string :title, null: false
      t.string :title_kana
      t.integer :volume, null: false
      t.integer :page, null: false
      t.date :release, null: false
      t.string :amazon_url
      t.string :rakuten_url
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
