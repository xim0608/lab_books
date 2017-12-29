class Users::InvitationsController < Devise::InvitationsController
  def edit
    super
  end

  def create
    super
  end

  private
  def update_resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :invitation_token)
  end
end