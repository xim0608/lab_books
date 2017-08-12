require 'will_paginate/array'

class BooksController < ApplicationController
  before_action :authenticate_user!


  def index
    # 人気タグ
    @tags = ActsAsTaggableOn::Tag.most_used(20)
    # 新着本
    @books = Book.order('id DESC').take(21)
    # @favorites = Favorites.all
  end

  def show_all
    @books = Book.ja_search(params[:q]).order('publish_year').paginate(:page => params[:page], :per_page => 20)
    @tags = ActsAsTaggableOn::Tag.most_used(20)
  end

  def import_from_csv
  end

  def show
    @book = Book.find(params[:id])
   # begin
     # res = Amazon::Ecs.item_lookup(@book.isbn_10, ResponseGroup: 'Reviews')
     # @url = res.get_element('CustomerReviews').get('IFrameURL')
   # rescue
   #   puts '503 error'
   # end
  end

  def show_review
    require 'timeout'
    @book = Book.find(params[:book_id])
    counter = 0
    begin
      Timeout.timeout(2) do
        res = Amazon::Ecs.item_lookup(@book.isbn_10, ResponseGroup: 'Reviews')
        url = res.get_element('CustomerReviews').get('IFrameURL')
        render json: {url: url}
      end
    rescue Timeout::Error
      render json: {error: 'timeout'}
    rescue
      puts '503 error'
      counter += 1
      if counter <= 3
        retry
      end
      render json: {error: '503 error'}
    end
  end

  def import
    counter = Book.import(params[:file])
    if counter >= 1
      notice_msg = "#{counter}件登録しました！"
    else
      notice_msg = '1件も登録されませんでした'
    end
    redirect_to books_path, notice: notice_msg
  end

  # API
  def rent
  end

  def return
  end
end

