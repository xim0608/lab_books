require 'will_paginate/array'

class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_show_num
  protect_from_forgery except: [:change_show_num]

  def index
    # 人気タグ
    @tags = ActsAsTaggableOn::Tag.most_used(20)
    # 新着本
    @books = Book.preload(:rental).order('id DESC').take(session[:show_num])
  end

  def search
    books = Book.ja_search(params[:q])
    if params[:q].present?
      if ActsAsTaggableOn::Tag.pluck(:name).include?(params[:q])
        tag = ActsAsTaggableOn::Tag.where(name: params[:q]).first
        @books_size = tag[:taggings_count]
      else
        @books_size = books.count
      end
    end
    @books = books.preload(:rental).order('publish_year').paginate(:page => params[:page], :per_page => session[:show_num])
    @tags = ActsAsTaggableOn::Tag.most_used(20)
  end

  def import_from_csv
  end

  def show
    @book = Book.find(params[:id])
    @tags = @book.tags
  end

  def review_html
    require 'timeout'
    book = Book.find(params[:book_id])
    # render body: StyleInliner::Document.new(book.review_html, replace_properties_to_attributes: true).inline
    render body: book.review_html
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

  def change_show_num
    session[:show_num] = params[:show_num].to_i
  end

  def recommends
    render json: Book.find(params[:id]).recommends
  end

  private

  def set_show_num
    session[:show_num] ||= 20
  end

end
