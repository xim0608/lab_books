class CreateFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.references :user, null:false
      t.references :book, null:false
      t.timestamps null: false
    end
  end
end
