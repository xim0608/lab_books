class ApiController < ApplicationController
  # protect_from_forgery except: [:search, :rent, :return]
  protect_from_forgery except: [:data_catcher]
  require 'json'
  def search
    raise unless params[:q]
    results = Book.ja_search(params[:q])
    render json: results.to_json({only: %w(name image_url)})
  end

  # def add
  #   book = Book.find_by_isbn_10(params[:isbn_10]).take(1)
  #   render json: {book: book}
  # end
  #
  # def rent
  #   # id = student_id
  #   # isbn_10[] = isbn_10
  #   # isbn_10[] = ~
  #   # isbn_10[] = ~
  #   # ...
  #   user = User.find_by_student_id(params[:id])
  #   books = Book.find_by_isbn_10(params[:isbn_10])
  #   render json: {user: user, book: books}
  # end
  #
  # def return
  #   user = User.find_by_student_id(params[:id])
  #   books = Book.find_by_isbn_10(params[:isbn_10])
  #   render json: {user: user, book: books}
  # end

  def data_catcher
    json_request = JSON.parse(request.body.read)
    student_id = json_request['student_id']
    books_isbn = json_request['books']
    user = User.find_by_student_id(student_id)
    books_isbn.each do |book_isbn|
      len = book_isbn.to_s.length
      book = Book.find_by_isbn_10(book_isbn) if len == 10
      book = Book.find_by_isbn_13(book_isbn) if len == 13
      if book.rental.user == user
        # 本が今借りているものなら返却
        book.rental.soft_destroy
      else
        user.rentals.create book: book
      end
    end
  end
end
