class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def slack
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = 'devise.omniauth_callbacks.success'
      @user.deleted_at = nil
      @user.save
      sign_in_and_redirect @user, event: :authentication
    else
      redirect_to error_path
    end
  end

  def passthru
    super
  end
end

