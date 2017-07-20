class AddAndDeleteColumnToRentals < ActiveRecord::Migration[5.1]
  def up
    remove_column :rentals, :soft_destroyed_at
    add_column :rental_histories, :unread, :boolean, null: false, default: true
  end

  def down
    add_column :rentals, :soft_destroyed_at, :datetime
    remove_column :rental_histories, :unread
  end
end
