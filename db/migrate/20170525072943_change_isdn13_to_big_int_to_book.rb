class ChangeIsdn13ToBigIntToBook < ActiveRecord::Migration[5.1]
  def change
    change_column :books, :isbn_13, :integer, :limit => 8, unique: :true
  end
end
