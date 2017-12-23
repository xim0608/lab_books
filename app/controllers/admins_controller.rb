class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
  end

  def users
    @b3s = User.where(year: 'B3')
    @b4s = User.where(year: 'B4')
    @m1s = User.where(year: 'M1')
    @m2s = User.where(year: 'M2')
    @books_sum = Rental.now.group(:user_id).sum(:user_id)
  end

  def show
    @user = User.find(params[:user_id])
    @rentals = @user.rentals.now
  end

  def change_flag
    @user = User.find(params[:user_id])
    @book = Book.find(params[:book_id])
    return_data = {}
    ActiveRecord::Base.transaction do
      # 例外が発生するかもしれない処理
      if @book.rental.present?
        if @book.rental.return_at.nil? and @book.rental.user.id == @user.id
          @book.rental.soft_destroy
          return_data.merge!(title: '返却：' + @book.name, author: @book.author)
        else
          return_data.merge!(title: 'エラー：' + @book.name, author: @book.author)
          if @book.rental.user.name.present?
            logger.error(@book.rental.user.name + 'が借りている本を貸し出そうとしました')
          end
        end
      else
        @user.rentals.create book: @book
        return_data.merge!(title: '貸出：' + @book.name, author: @book.author)
      end
    end
    render json: return_data
  end

end
