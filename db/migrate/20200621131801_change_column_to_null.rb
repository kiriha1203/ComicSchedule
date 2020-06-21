class ChangeColumnToNull < ActiveRecord::Migration[5.2]
  def up
    change_column_null :books, :author, true
    change_column_null :books, :label, true
    change_column_null :books, :issue_from, true
    change_column_null :book_details, :volume, true
    change_column_null :book_details, :page, true
    change_column_null :book_details, :release, true
  end

  def down
    change_column_null :books, :author, false
    change_column_null :books, :label, false
    change_column_null :books, :issue_from, false
    change_column_null :book_details, :volume, false
    change_column_null :book_details, :page, false
    change_column_null :book_details, :release, false
  end
end
