class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def slack
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = 'devise.omniauth_callbacks.success'
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.slack_data"] = request.env['omniauth.auth'].except("extra")
      redirect_to new_user_registration_url
    end
  end
end
