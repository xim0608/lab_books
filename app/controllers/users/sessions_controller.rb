class Users::SessionsController < Devise::SessionsController
  def new
    # emailでのsign_inができないようにする(routesで設定するのが大変)
    redirect_to root_path
  end

  def destroy

  end
end

