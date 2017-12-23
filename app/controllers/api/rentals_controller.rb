module Api
  class RentalsController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    before_action :authenticate_user!

    def index
      # TODO
    end

    def create
      # TODO
    end
  end
end
