class AddColumnToRentals < ActiveRecord::Migration[5.1]
  def up
    add_column :rentals, :unread, :boolean, null: false, default: true
  end

  def down
    remove_column :rentals, :unread
  end
end
