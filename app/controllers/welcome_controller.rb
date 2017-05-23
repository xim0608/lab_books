class WelcomeController < ApplicationController
  def index
    if current_user
      redirect_to books_path
    else
      render 'welcome/index'
    end
  end

  def error
  end
end
