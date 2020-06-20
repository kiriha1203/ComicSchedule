class CreateScrapings < ActiveRecord::Migration[5.2]
  def change
    create_table :scrapings do |t|

      t.timestamps
    end
  end
end
