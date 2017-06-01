class Book < ApplicationRecord
  include SearchCop
  acts_as_taggable_on :labels
  acts_as_taggable

  search_scope :search do
    attributes :name, :description
  end

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

  def self.ja_search(query)
    results = self.search(query)
    if query.present?
      size = results.size
      # 全角スペース置換
      query.gsub!('　', ' ')

      # 一単語のみで検索しているか
      unless query.include?(' ')
        okura = WordManipulation::OkuraConnector.new
        # queryが一般名詞のみで構成されているか
        if okura.is_noun?(query)
          if size > 3 && size < self.all.size
            results.each do |book|
              book.tag_list.add(query)
              book.save
            end
          end
        end
      end
    end
    results
  end

  # def self.search(query)
  #   if query
  #     where(['name LIKE ? OR description LIKE ?', "%#{query}%", "%#{query}%"])
  #   else
  #     all
  #   end
  # end
  #
  # def self.search_and_tagging(query)
  #   search_results = self.search(query)
  #   result_length = search_results.size
  #   puts result_length
  #   if result_length >= 5 && result_length < 200
  #     search_results.each do |book|
  #       puts book.name
  #       book.tag_list.add(query)
  #       book.save
  #     end
  #   end
  #   search_results
  # end
end
