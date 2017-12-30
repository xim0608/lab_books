module Users
  class InvitationsController < Devise::InvitationsController

    def edit
      super
    end

    def create
      self.resource = invite_resource
      Rails.logger.info("resource: " + self.resource.to_s)
      if self.resource == false
        respond_with_navigational(resource) {render :new}
      else
        resource_invited = resource.errors.empty?
        yield resource if block_given?

        if resource_invited
          if is_flashing_format? && self.resource.invitation_sent_at
            @resource = resource
            text = ERB.new(File.read("#{Rails.root}/app/views/devise/mailer/invitation_instructions.text.erb")).result(binding)
            res = Slack.chat_postMessage(text: text, username: 'labooks', channel: "@#{resource.slack_name}")
            Rails.logger.info(res)
            if res['ok'] == false
              redirect_to new_user_invitation_path, alert: "エラーが発生しました"
            end
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
    def invite_resource(&block)
      # check user presence
      # temporary_mail: 'myjlab@username'
      email = invite_params['email']
      user_info = invite_params
      slack_name = ''
      Slack.users_list['members'].each do |user|
        next unless user['profile']
        next if user['is_bot']
        if email == user['profile']['email']
          user_info['name'] = user['profile']['real_name']
          user_info['slack_name'] = user['name']
          break
        end
      end
      if user_info.size > 1
        resource_class.invite!(user_info, current_inviter, &block)
      else
        # no slack user
        false
      end
    end

    def update_resource_params
      params.require(:user).permit(:password, :password_confirmation, :invitation_token)
    end
  end
end
