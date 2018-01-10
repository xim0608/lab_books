module Users
  class PasswordsController < Devise::PasswordsController
    def create
      password_reset_user = User.find_by(email: resource_params[:email])
      token = password_reset_user.send_reset_password_instructions
      unless password_reset_user.present?
        redirect_to new_reset_password_path, flash: {alert: 'ユーザが存在しません'}
      end
      slack_name = password_reset_user.slack_name
      if slack_name.blank?
        Slack.users_list['members'].each do |user|
          next unless user['profile']
          next if user['is_bot']
          if email == user['profile']['email']
            slack_name = user['name']
            break
          end
        end
      end
      @resource = password_reset_user
      @token = token
      text = ERB.new(File.read("#{Rails.root}/app/views/devise/mailer/reset_password_instructions.text.erb")).result(binding)
      res = Slack.chat_postMessage(text: text, username: 'labooks', channel: "@#{slack_name}")
      Rails.logger.info(res)
    end
  end
end
