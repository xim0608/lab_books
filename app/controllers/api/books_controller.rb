module Api
  class BooksController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    before_action :authenticate_user!

    def index
      render json: Book.all.take(5).to_json
    end
  end
end
