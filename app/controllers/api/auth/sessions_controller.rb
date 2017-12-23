class Api::SessionsController < DeviseTokenAuth::SessionsController
  protect_from_forgery except: [:new, :create, :destroy]
end