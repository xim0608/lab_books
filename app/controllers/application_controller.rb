class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if current_user.student_id.blank?
      edit_user_registration_path
    else
      books_path
    end
  end

  def authenticate_admin!
    redirect_to books_path, alert: '権限がありません'  unless current_user.admin?
  end
  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name_ja, :nickname, :student_id])
  end
end

