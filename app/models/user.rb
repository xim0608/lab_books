class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :rememberable, :trackable, :recoverable
  include DeviseTokenAuth::Concerns::User

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :books, through: :favorites
  has_many :rentals
  has_many :rental_histories

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def admin?
    self.is_admin
  end

  def favorite?(book)
    self.favorites.find_by(book_id: book.id)
  end

  def favorite!(book)
    self.favorites.create!(book_id: book.id)
  end

  def unfavorite!(book)
    self.favorites.find_by(book_id: book.id).destroy
  end
end
