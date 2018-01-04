class Book < ApplicationRecord
  include SearchCop
  acts_as_taggable_on :labels
  acts_as_taggable

  search_scope :search do
    attributes :name, :description
  end

  search_scope :title_search do
    attributes :name
  end

  has_many :favorites
  has_many :users, through: :favorites
  has_one :rental, -> { where(return_at: nil) }

  def self.import(file)
    counter = 0
    CSV.foreach(file.path, encoding: Encoding::SHIFT_JIS) do |row|
      unless self.exists?(isbn_13: row[2].to_i)
        create(isbn_13: row[2].to_i, isbn_10: row[1], name: row[11],
             publisher: row[13], author: row[12], publish_year: row[14].to_i,
             pages: row[16].to_i)
        counter += 1
      end
    end
    counter
  end

  def self.import_from_api
    books = BookLog::Api.new(100).get_data
    books.each do |book|
      image_url = book[:image].sub('._SL75_', '')
      if self.exists?(book[:asin])
        create(author: book[:author], isbn_10: book[:asin], name: book[:title],
                               image_url: image_url)
        puts 'success'
      end
    end
  end

  def self.availables
    borrowed_books = Book.joins(:rental)
    books = Book.all
    books - borrowed_books
  end

  def self.ja_search(query)
    # 全角スペース置換
    query.gsub!('　', ' ') if query.present?
    self.search(query)
  end

  def self.admin_user_search(query, user)
    # 全角スペース置換
    query.gsub!('　', ' ') if query.present?
    borrowed_books = Book.joins(:rental).pluck(:id)
    borrowing_books = user.rentals.now.pluck(:book_id)
    books_json = Book.title_search(query).where.not(id: borrowed_books - borrowing_books).take(10).as_json
    books_json.each do |book|
      book["is_borrowing"] = true if borrowing_books.include?(book["id"])
    end
    books_json
  end

  def recommends
    books_id = Redis.current.get("books/sparse_recommends/#{self.id}")
    raise ActiveRecord::RecordNotFound if books_id.nil?
    Book.where(id: JSON.parse(books_id))
  end

end
