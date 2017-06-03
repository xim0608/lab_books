namespace :books do

  desc 'descriptionがない本のdescriptionを取得してdbに登録'
  task :get_description => :environment do
    no_description_books = Book.where(description: nil).take(500)
    no_description_books.each do |book|
      isbn = book.isbn_13.to_s || book.isbn_10.to_s
      book.description = GoogleBooks::Api.new(isbn).get_description
      book.save
      puts "#{book.name}'s description is successfully saved"
    end
  end

  desc '写真URLがない本の写真URLを取得してDBに登録'
  task :get_image => :environment do
    no_images_books = Book.where(image_url: nil).take(50)
    no_images_books.each do |book|
      begin
        res = Amazon::Ecs.item_lookup(book.isbn_10, ResponseGroup: 'Images')
        puts res.get_element('LargeImage').get('URL')
        book.image_url = res.get_element('LargeImage').get('URL')
        book.save
      rescue
        puts 'too many requests'
        sleep(1)
        retry
      end
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
