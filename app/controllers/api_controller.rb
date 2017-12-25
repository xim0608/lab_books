class ApiController < ApplicationController
  before_action :authenticate_admin!, only: [:add]

  require 'json'
  require 'jwt'
  require 'net/http'

  def check_book
    book_isbn = params[:book_isbn].to_s
    if book_isbn.length == 10
      book = Book.find_by(isbn_10: book_isbn)
    else
      book = Book.find_by(isbn_13: book_isbn)
    end
    title = book.name
    author = book.author
    render json: [{ title: title, author: author }]
    # render json: [{title: "title", author: "author"}]
  end

  def search
    raise unless params[:q]
    results = Book.ja_search(params[:q])
    render json: results.to_json({ only: %w[name image_url] })
  end

  def inc_search
    raise unless params[:q] || params[:uid]
    user = User.find(params[:uid])
    results = Book.admin_user_search(params[:q], user)
    render json: results.to_json({ only: %w[id name author image_url is_borrowing] })
  end

  def inc_list
  end

  def add
    book = Book.find_by(isbn_10: params[:isbn_10]).take(1)
    render json: { book: book }
  end

  def data_catcher
    json_request = JSON.parse(request.body.read)
    student_id = json_request['studentNum']
    books_isbn = json_request['books_isbn']
    logger.info(books_isbn)
    return_data = []
    user = User.find_by(student_id: student_id)
    books_isbn.each do |book_isbn|
      len = book_isbn.to_s.length
      book = Book.find_by(isbn_10: book_isbn) if len == 10
      book = Book.find_by(isbn_13: book_isbn) if len == 13
      ActiveRecord::Base.transaction do
        # 例外が発生するかもしれない処理
        if book.rental.present?
          if book.rental.user.id == user.id
            book.rental.soft_destroy
            return_data.append({ title: '返却：' + book.name, author: book.author })
          else
            return_data.append({ title: 'エラー：' + book.name, author: book.author })
            logger.error(book.rental.user.name + 'が借りている本を貸し出そうとしました') if book.rental.user.name.present?
          end
        else
          user.rentals.create! book: book
          return_data.append({ title: '貸出：' + book.name, author: book.author })
        end
      end
    end
    logger.info(return_data)
    render json: return_data
  end
end
