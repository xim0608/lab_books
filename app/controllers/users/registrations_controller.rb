class Users::RegistrationsController < Devise::RegistrationsController
  def new
    # sign_upはできないようにする(routesで設定するのが大変)
    redirect_to root_path
  end

  def destroy
    current_user.deleted_at = Time.now
    current_user.save
    redirect_to destroy_user_registration_path
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end

