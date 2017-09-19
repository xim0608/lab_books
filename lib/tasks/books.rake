namespace :books do

  desc 'descriptionがない本のdescriptionを取得してdbに登録'
  task :get_description_from_google => :environment do
    # google books free枠は1000 queries per day
    no_description_books = Book.where(description: nil).take(1000)
    no_description_books.each do |book|
      isbn = book.isbn_10.to_s
      book.description = GoogleBooks::Api.new(isbn).get_description
      book.save
      puts "#{book.name}'s description is successfully saved"
    end
  end

  desc 'descriptionがない本のdescriptionをOpenBDから取得してdbに登録'
  task :get_description_from_openbd => :environment do
    # google books free枠は1000 queries per day
    no_description_books = Book.where(description: nil).take(5)
    no_description_books.each do |book|
      isbn = book.isbn_13.to_s
      book.description = OpenBd::Api.new(isbn).get_description
      # book.save
      puts "#{book.name}'s description is successfully saved"
    end
  end

  desc '写真URLがない本の写真URLを取得してDBに登録'
  task :get_image => :environment do
    no_images_books = Book.where(image_url: nil)
    no_images_books.each do |book|
      counter = 0
      begin
        res = Amazon::Ecs.item_lookup(book.isbn_10, ResponseGroup: 'Images')
        puts res.error
        puts res.get_element('LargeImage').get('URL')
        book.image_url = res.get_element('LargeImage').get('URL')
        book.save
      rescue
        puts 'too many requests'
        sleep(1)
        counter += 1
        if counter < 5
          retry
        else
          next
        end
      end
    end
  end

  desc 'ブクログ上の新しい本100件をチェック、dbになければ登録'
  task :get_new_book => :environment do
    Book.import_from_api
  end

  desc 'はてなキーワードAPIに本のデータを送信し、特徴語を取り出してタグ付け'
  task :tagging_books => :environment do
    require 'xmlrpc/client'

    server = XMLRPC::Client.new2('http://d.hatena.ne.jp/xmlrpc')
    Book.all.each do |book|
      text = "#{book.name} #{book.description}"
      begin
        param = server.call("hatena.setKeywordLink", {"body": text, 'mode': 'lite'})
        words = param["wordlist"]
        words.each do |word|
          if word['score'] > 25
            book.tag_list.add(word['word'])
            book.save
          end
        end
      rescue XMLRPC::FaultException => e
        puts "Error:"
        puts e.faultCode
        puts e.faultString
        retry
      end
      p "success tagging to #{book.name}"
    end
  end
end
