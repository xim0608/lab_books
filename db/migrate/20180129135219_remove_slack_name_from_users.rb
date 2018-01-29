class RemoveSlackNameFromUsers < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :slack_name
  end

  def down
    add_column :users, :slack_name, :string, default: ''
  end
end
