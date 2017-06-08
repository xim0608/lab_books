class BooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = Book.all
  end

  def show_all
    @books = Book.ja_search(params[:q]).order('publish_year').paginate(:page => params[:page], :per_page => 20)
  end

  def import_from_csv
  end

  def show
    @book = Book.find(params[:id])
    begin
      res = Amazon::Ecs.item_lookup(@book.isbn_10, ResponseGroup: 'Reviews,Images')
      @image = res.get_element('LargeImage').get('URL')
      @url = res.get_element('CustomerReviews').get('IFrameURL')
    rescue
      puts '503 error'
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

  def rent
  end

  def return
  end

end

