class ChangeColumnToUser < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
    add_column :users, :deleted_at, :datetime
  end

  def down
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :remember_created_at, :datetime
    remove_column :users, :deleted_at
  end
end
