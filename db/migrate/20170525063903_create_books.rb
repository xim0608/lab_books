class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.integer :isbn_13
      t.string :isbn_10
      t.string :name
      t.string :publisher
      t.string :author
      t.text :image_url
      t.integer :publish_year
      t.integer :pages
      t.integer :user_id

      t.timestamps

    end

    add_index :books, :isbn_13, unique: :true
    add_index :books, :isbn_10, unique: :true
  end
end
