class BooksController < ApplicationController
  before_action :authenticate_user!

  def index
    # book list
    @books = Book.order('publish_year').paginate(:page => params[:page], :per_page => 20)
  end

  def import_from_csv
  end

  def show
    # book
  end

  def import
    counter = Book.import(params[:file])
    redirect_to books_path, notice: "#{counter}件登録しました！"
  end

  def rent

  end

  def return

  end
end
