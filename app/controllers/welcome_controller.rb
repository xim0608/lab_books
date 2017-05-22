class WelcomeController < ApplicationController
  def index
    if current_user
      redirect_to books_path
    else
      redirect_to user_slack_omniauth_authorize_path
    end
  end
end
