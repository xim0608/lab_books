class AddReturnColumnToRentals < ActiveRecord::Migration[5.1]
  def change
    add_column :rentals, :return_at, :datetime
  end
end
