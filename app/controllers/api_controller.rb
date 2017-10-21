class ApiController < ApplicationController
  # protect_from_forgery with: :null_session
  protect_from_forgery except: [:make_session]
  before_action :authenticate_admin!, only: [:add]

  require 'json'
  require 'jwt'
  require 'net/http'

  def make_session
    # slack.com/oauth/authorize?client_id=169915681349.170498868550&scope=identity.basic へアクセスした時のcallback
    # slack.comからのcallbackを受ける
    code = params[:code]
    payload = URI.encode_www_form({client_id: ENV['SLACK_APP_ID'], client_secret: ENV['SLACK_APP_SECRET'], code: code})
    oauth_access_uri = URI.parse("https://slack.com/api/oauth.access?#{payload}")

    req = Net::HTTP::Get.new(oauth_access_uri.request_uri)
    req['Accept'] = 'application/json'

    res = Net::HTTP.start(oauth_access_uri.host, oauth_access_uri.port, :use_ssl => oauth_access_uri.scheme == 'https') do |http|
      http.request(req)
    end

    oauth_access = JSON.parse(res.body)
    if oauth_access['ok'].present?
      uid = oauth_access['user']['id']
      user = User.find_by(uid: uid)
      if user.is_admin?
        logger.info("logged_in admin_user from iphone: #{user}")
      else
        return false
      end
      render json: {'user': user.name}
      # トークン生成
      # token =
    end

    # hmac_secret = ENV['HMAC_SECRET']
    # token = JWT.encode payload, hmac_secret, 'HS256'


    # render json: res.body
    # payload = {jwt: token, exp: ""}

  end

  def search
    raise unless params[:q]
    results = Book.ja_search(params[:q])
    render json: results.to_json({only: %w(name image_url)})
  end

  def inc_search
    raise unless params[:q]
    results = Book.ja_title_search(params[:q]).take(10)
    render json: results.to_json({only: %w(id name author image_url)})
  end

  def inc_list

  end

  def add
    book = Book.find_by_isbn_10(params[:isbn_10]).take(1)
    render json: {book: book}
  end
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
      ActiveRecord::Base.transaction do
        # 例外が発生するかもしれない処理
        if book.rental.present?
          if book.rental.user.id == user.id
            book.rental.soft_destroy
          end
        else
          user.rentals.create book: book
        end
      end
    end
    return

  end
end

