namespace :books do

  # desc 'descriptionがない本のdescriptionを取得してdbに登録'
  # task :get_description_from_google => :environment do
  #   # google books free枠は1000 queries per day
  #   no_description_books = Book.where(description: nil).take(1000)
  #   no_description_books.each do |book|
  #     isbn = book.isbn_10.to_s
  #     book.description = GoogleBooks::Api.new(isbn).get_description
  #     book.save
  #     puts "#{book.name}'s description is successfully saved"
  #   end
  # end

  desc 'descriptionがない本のdescriptionをOpenBDから取得してdbに登録'
  task :get_description => :environment do
    no_description_books = Book.all
    no_description_books.each do |book|
      isbn = book.isbn_13.to_s
      descriptions = OpenBd::Api.new(isbn).get_description
      if descriptions[:description].blank?
        book.description = GoogleBooks::Api.new(isbn).get_description
        sleep(1)
      else
        book.description = descriptions[:description]
      end
      book.outline = descriptions[:outline]
      book.save
      puts "#{book.name}'s description is successfully saved"
    end
  end

  desc 'isbn_13がない本のisbn13をopenbdから取得してdbに登録'
  task :get_booklog_missing => :environment do
    # booklogのapiから取得した本には、isbn_13, publisher, author, publish_year, pagesが欠けている
    no_13_books = Book.where(isbn_13: nil)
    no_13_books.each do |book|
      isbn_10 = book.isbn_10.to_s
      datas = OpenBd::Api.new(isbn_10).get_booklog_missing
      book.isbn_13 = datas[:isbn_13]
      book.publisher = datas[:publisher]
      book.author = datas[:author]
      book.publish_year = datas[:publish_year]
      book.save
    end
  end

  desc 'isbn_13がない本のisbn13をopenbdから取得してdbに登録'
  task :get_isbn_13 => :environment do
    # booklogのapiから取得した本には、isbn_13, publisher, author, publish_year, pagesが欠けている
    no_13_books = Book.where(isbn_13: nil)
    no_13_books.each do |book|
      counter = 0
      p book.name
      begin
        sleep(1)
        res = Amazon::Ecs.item_lookup(book.isbn_10, ResponseGroup: 'ItemAttributes')
        unless res.get_element('Format').nil?
          if res.get_element('Format').get == 'Kindle本'
            next
          end
        end
        isbn_13 = res.get_element('EAN').get if res.get_element('EAN').present?
        publisher = res.get_element('Label').get if res.get_element('Label').present?
        author = res.get_element('Author').get if res.get_element('Author').present?
        publish_year = res.get_element('PublicationDate').get.slice(0, 4).to_i if res.get_element('PublicationDate').present?
        pages = res.get_element('NumberOfPages').get.to_i if res.get_element('NumberOfPages').present?
        book.isbn_13 = isbn_13
        book.publisher = publisher || nil
        book.author = author || nil
        book.publish_year = publish_year || nil
        book.pages = pages || nil
        book.save
      rescue => e
        p e.message
        puts '503 error'
        counter += 1
        if counter <= 3
          retry
          sleep(1)
        else
          next
        end
      end

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
