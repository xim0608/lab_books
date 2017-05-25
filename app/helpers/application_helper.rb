module ApplicationHelper
  def authenticate_user!(opts={})
    opts[:scope] = :user
    warden.authenticate!(opts) if !devise_controller? || opts.delete(:force)
  end

  def user_signed_in?
    !!current_user
  end

  def current_user
    @current_user ||= warden.authenticate(:scope => :user)
  end

  def user_session
    current_user && warden.session(:user)
  end
end
