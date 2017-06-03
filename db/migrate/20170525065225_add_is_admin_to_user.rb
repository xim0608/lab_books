class AddIsAdminToUser < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :is_admin, :boolean, default: false
  end

  def down
    remove_column :users, :is_admin
  end
end
