class AddNotificationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification, :integer
  end
end
