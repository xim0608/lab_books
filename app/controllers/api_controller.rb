class ApiController < ApplicationController
  protect_from_forgery except: [:search, :rent, :return]
  require 'json'
  def search
    raise unless params[:q]
    results = Book.ja_search(params[:q])
    render json: results.to_json({only: %w(name image_url)})
  end

  def rent
    # id = student_id
    # isbn_10[] = isbn_10
    # isbn_10[] = ~
    # isbn_10[] = ~
    # ...
    user = User.find_by_student_id(params[:id])
    books = Book.find_by_isbn_10(params[:isbn_10])
    render json: {user: user, book: books}
  end

  def return
    user = User.find_by_student_id(params[:id])
    books = Book.find_by_isbn_10(params[:isbn_10])
    render json: {user: user, book: books}
  end

end
