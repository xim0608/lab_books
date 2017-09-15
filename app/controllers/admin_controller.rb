class AdminController < ApplicationController
  before_action :authenticate_admin!

  def index
    @b3s = User.where(year: 'B3')
    @b4s = User.where(year: 'B4')
    @m1s = User.where(year: 'M1')
    @m2s = User.where(year: 'M2')
    @books_sum = Rental.group(:user_id).sum(:user_id)
  end

  def show
    @user = User.find(params[:user_id])
    @rental_books = @user.rentals
  end

  end
