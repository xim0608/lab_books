class FavoritesController < ApplicationController
  protect_from_forgery except: [:create]

  def index
    @user = current_user
    # @favorites = Favorite.where(user_id: @user.id).all
    @books = Book.includes(:favorites).where(favorites: {user_id: @user.id})
  end

  def create
    @book = Book.find(params[:book_id])
    current_user.favorite!(@book)
  end

  def destroy
    @book = Favorite.find(params[:id]).book
    current_user.unfavorite!(@book)
  end

  def show_clips
    @book = Book.find(params[:id])
    @users = User.includes(:favorites).where(favorites: {book_id: @book.id})
  end
end
