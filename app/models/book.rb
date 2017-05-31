class Book < ApplicationRecord
  # いま本がどこにあるのかわかるようにする
  belongs_to :where, class_name: 'User', foreign_key: 'user_id'



  def self.import(file)
    counter = 0
    default_user = User.where(name: ENV['ADMINISTRATOR_NAME'])
    CSV.foreach(file.path, encoding: Encoding::SHIFT_JIS) do |row|
      unless self.exists?(isbn_13: row[2].to_i)
        create(isbn_13: row[2].to_i, isbn_10: row[1], name: row[11],
             publisher: row[13], author: row[12], publish_year: row[14].to_i,
             pages: row[16].to_i, user_id: default_user.ids[0])
        counter += 1
      end
    end
    counter
  end

  def self.search(query)
    if query
      where(['name LIKE ? OR description LIKE ?', "%#{query}%", "%#{query}%"])
    else
      all
    end
  end
end
