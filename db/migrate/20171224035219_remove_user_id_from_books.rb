class RemoveUserIdFromBooks < ActiveRecord::Migration[5.1]
  def up
    remove_column :books, :user_id
  end

  def down
    add_column :books, :user_id, :integer
  end
end
