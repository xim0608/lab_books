class AddRememberCreatedAtToUser < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :remember_created_at, :datetime
  end

  def down
    remove_column :users, :remember_created_at
  end
end
