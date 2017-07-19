class RentalsController < ApplicationController
  def show_by_student_id
    @user = User.find_by_student_id(params[:student_id])
    @rental_books = @user.rentals
    render :layout => false
  end
end
