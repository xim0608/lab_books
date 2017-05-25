class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to books_path
    end
  end

  def error
  end
end
