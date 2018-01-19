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
  has_one :rental, -> {where(return_at: nil)}

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
    books_id = Redis.current.get("books/recommends/#{self.id}")
    raise ActiveRecord::RecordNotFound if books_id.nil?
    Book.where(id: JSON.parse(books_id))
  end

  def review_url
    require 'cgi'
    time_now = Time.current.to_i
    review_json = Redis.current.get("books/reviews/#{self.id}")
    if review_json.present?
      review = JSON.parse(review_json)
      if !review.key?('expiration_date') && time_now > review['expiration_date'].to_i
        save_review_iframe_url
      else
        review['url']
      end
    else
      save_review_iframe_url
    end
  end

  def rented?
    self.rental.present?
  end

  private
  def fetch_review_iframe_url
    max_attempts = 3
    attempts = 0
    begin
      res = Amazon::Ecs.item_lookup(self.isbn_10, ResponseGroup: 'Reviews')
    rescue Amazon::RequestError => e
      if attempts <= max_attempts
        retry
      else
        logger.error("tried 3 times, but error")
        logger.error(e.message)
        return ''
      end
    end
    res.get_element('CustomerReviews').get('IFrameURL')
  end

  def save_review_iframe_url
    url = fetch_review_iframe_url
    # URLに付与されているparameterから有効期限を取得
    exp = Time.parse(CGI::parse(url).symbolize_keys[:exp].first).to_i
    save_json = {url: url, expiration_date: exp}
    Redis.current.set("books/reviews/#{self.id}", save_json.to_json)
    url
  end
end
