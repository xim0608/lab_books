class AddSlackNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :slack_name, :string, default: ''
  end
end
