class RemoveNameJaFromUsers < ActiveRecord::Migration[5.1]
  def up
    remove_index :users, :uid
    remove_column :users, :name_ja
    remove_column :users, :uid
  end

  def down
    add_column :users, :name_ja, :string
    add_column :users, :uid, :string
    add_index :users, :uid, unique: true
  end
end
