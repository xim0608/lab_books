class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if current_user.student_id.blank?
      edit_user_registration_path
    else
      books_path
    end
  end

  def authenticate_admin!
    redirect_to books_path, alert: '権限がありません' unless current_user.admin?
  end

  def rent_books(opts={})
    # identify user
    # student_id or user_id
    user = User.find(student_id: opts[:student_id]) if opts.key?(:student_id)
    user = User.find(opts[:user_id]) if opts.key?(:user_id)
    raise Exception unless defined?(user)

    status = {}
    opts[:books_isbn].each do |isbn|
      book = Book.find(isbn_10: isbn) if isbn.size == 10
      book = Book.find(isbn_13: isbn) if isbn.size == 13

      ActiveRecord::Base.transaction do
        # 例外が発生するかもしれない処理
        if book.rental.present?
          if book.rental.user.id == user.id
            status.store(isbn, 'already rented')
          end
        else
          user.rentals.create book: book
          status.store(isbn, 'success')
        end
      end
    end
    status
  end

  def return_books(opts={})
    user = User.find(student_id: opts[:student_id]) if opts.key?(:student_id)
    user = User.find(opts[:user_id]) if opts.key?(:user_id)
    raise Exception unless defined?(user)

    status = {}
    opts[:books_isbn].each do |isbn|
      book = Book.find(isbn_10: isbn) if isbn.size == 10
      book = Book.find(isbn_13: isbn) if isbn.size == 13

      ActiveRecord::Base.transaction do
        # 例外が発生するかもしれない処理
        if book.rental.present?
          if book.rental.user.id == user.id
            # rentalを削除して、historyへ
            status.store(isbn, 'success')
            book.rental.soft_destroy!
          end
        else
          status.store(isbn, 'no record')
        end
      end
    end
    status
  end

  protected
    def authenticate_inviter!
      authenticate_admin!
    end



  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :nickname, :student_id, :year])
  end
end

