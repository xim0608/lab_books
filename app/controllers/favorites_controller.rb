class FavoritesController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    @user_id = current_user.id
    books = current_user.favorites.pluck(:book_id)
    @book_id = Book.find(params[:id]).id
    if books.include?(@book_id)
      @favorite = current_user.favorites.where(book_id: @book_id).first
      @favorite.destroy
    else
      @favorite = Favorite.new(book_id: @book_id, user_id: @user_id)
      @favorite.save
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
  end

  def index
    @user = current_user
    # @favorites = Favorite.where(user_id: @user.id).all
    @books = Book.includes(:favorites).where(favorites: {user_id: @user.id})
  end

  def list
    user = current_user
    favorite_books = Book.includes(:favorites).where(favorites: {user_id: user.id}).pluck(:id)
    # お気に入りに追加した本のidの配列を返す
    render json: favorite_books.to_json
  end

  def show_clips
    @book = Book.find(params[:id])
    @users = User.includes(:favorites).where(favorites: {book_id: @book.id})

  end
end

