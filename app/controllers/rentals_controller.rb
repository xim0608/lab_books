class RentalsController < ApplicationController
  def show_by_student_id
    @user = User.find_by_student_id(params[:student_id])
    @rental_books = @user.rentals
    rental_histories = @user.rental_histories.unread
    @rental_histories = rental_histories
    render :layout => false
  end

  def change_unread_flag
    user = User.find_by_student_id(params[:student_id])
    rental_histories = user.rental_histories.unread
    rental_histories.update_all(unread: false)
  end
end
