class AddDescriptionToBook < ActiveRecord::Migration[5.1]
  def up
    add_column :books, :description, :text
  end

  def down
    remove_column :users, :description
  end
end
