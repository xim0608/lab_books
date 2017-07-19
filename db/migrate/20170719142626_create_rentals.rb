class CreateRentals < ActiveRecord::Migration[5.1]
  def change
    create_table :rentals do |t|
      t.references :book, null: false
      t.references :user, null: false
      t.datetime :soft_destroyed_at

      t.timestamps
    end
    add_index :rentals, :soft_destroyed_at
  end
end
