class AddOutlineToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :outline, :text
  end
end
