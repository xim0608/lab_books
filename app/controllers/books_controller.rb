require 'will_paginate/array'

class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_show_type, :set_show_num, :check_notice_or_error
  protect_from_forgery except: [:change_show_type, :change_show_num]

  def index
    # 人気タグ
    @tags = ActsAsTaggableOn::Tag.most_used(20)
    # 新着本
    @books = Book.order('id DESC').take(session[:show_num])
    # @favorites = Favorites.all
  end

  def show_all
    books = Book.ja_search(params[:q])
    if params[:q].present?
      if ActsAsTaggableOn::Tag.pluck(:name).include?(params[:q])
        tag = ActsAsTaggableOn::Tag.where(name: params[:q]).first
        @books_size = tag[:taggings_count]
      else
        @books_size = books.count
      end
    end
    @books = books.order('publish_year').paginate(:page => params[:page], :per_page => session[:show_num])
    @tags = ActsAsTaggableOn::Tag.most_used(20)
  end

  def import_from_csv
  end

  def show
    @book = Book.find(params[:id])
    @tags = @book.tags
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

  def change_show_type
    if params[:show_type] == 'with_image'
      session[:show_type] = 'with_image'
    else
      session[:show_type] = 'without_image'
    end
  end

  def change_show_num
    session[:show_num] = params[:show_num].to_i
  end


  # API
  def rent
  end

  def return
  end

  private
  def set_show_type
    session[:show_type] ||= 'with_image'
  end

  def set_show_num
    session[:show_num] ||= 20
  end

  def check_notice_or_error
    # flash[:notice] =
  end
end

