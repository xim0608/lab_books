class ReviewWorker
  include Sidekiq::Worker

  def perform(book_id, user_agent)
    Book.find(book_id).save_review_iframe_html(user_agent)
  end
end
