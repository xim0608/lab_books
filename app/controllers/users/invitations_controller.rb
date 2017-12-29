class Users::InvitationsController < Devise::InvitationsController
  def edit
    super
  end

  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?

    @token = resource.invitation_token

    # temporary_mail: 'myjlab@username'
    temporary_mail = invite_resource.email.split('@')
    if temporary_mail.size > 1
      slack_user = temporary_mail[1]
      @resource = invite_resource
      text = ERB.new(File.read("#{Rails.root}/app/views/devise/mailer/invitation_instructions.text.erb")).result(binding)
      res = Slack.chat_postMessage(text: text, username: 'labooks', channel: "@#{slack_user}")
      Rails.logger.info(res)
    else
      res = {'ok': false}
    end

    if res['ok'] == false
      redirect_to new_user_invitation_path, alert: "#{slack_user}というユーザはgroupに存在しません"
    else
      if resource_invited
        if is_flashing_format? && self.resource.invitation_sent_at
          set_flash_message :notice, :send_instructions, :email => self.resource.email
        end
        if self.method(:after_invite_path_for).arity == 1
          respond_with resource, :location => after_invite_path_for(current_inviter)
        else
          respond_with resource, :location => after_invite_path_for(current_inviter, resource)
        end
      else
        respond_with_navigational(resource) {render :new}
      end
    end

  end

  private
  def update_resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :invitation_token)
  end
end