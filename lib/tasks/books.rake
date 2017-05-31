namespace :books do

  desc "descriptionがない本のdescriptionを取得してdbに記録"
  task :get_description => :environment do
    no_description_books = Book.where(description: nil).take(500)
    no_description_books.each do |book|
      isbn = book.isbn_13.to_s || book.isbn_10.to_s
      book.description = GoogleBooks::Api.new(isbn).get_description
      book.save
      puts "#{book.name}'s description is successfully saved"
    end
  end


  # desc "descriptionがない本のdescriptionを取得してdbに記録"
  # task :get_description => :environment do
  #   require 'google/apis/books_v1'
  #   require 'google/api_client/'
  #   no_description_books = Book.where(description: nil).take(5)
  #   service = Google::Apis::BooksV1::BooksService.new
  #   service.key = ENV["GOOGLE_BOOKS_API_KEY"]
  # end
end
