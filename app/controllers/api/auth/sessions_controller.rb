module Api
  module Auth
    class SessionsController < DeviseTokenAuth::SessionsController
      protect_from_forgery except: [:new, :create, :destroy]
    end
  end
end
