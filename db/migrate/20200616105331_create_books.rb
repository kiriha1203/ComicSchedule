class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :title_kana
      t.string :author, null: false
      t.string :label, null: false
      t.string :issue_from, null: false
      t.timestamps
    end
  end
end
