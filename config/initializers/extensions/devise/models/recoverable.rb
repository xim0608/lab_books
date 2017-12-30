module Devise
  module Models
    module Recoverable
      def send_reset_password_instructions
        token = set_reset_password_token
        send_reset_password_instructions_notification(token)
        token
      end

      protected

      def send_reset_password_instructions_notification(token)
        # send_devise_notification(:reset_password_instructions, token, {})
        slack_name = resource.slack_name
        raise
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
        @resource = resource
        @token = token
        text = ERB.new(File.read("#{Rails.root}/app/views/devise/mailer/reset_password_instructions.text.erb")).result(binding)
        res = Slack.chat_postMessage(text: text, username: 'labooks', channel: "@#{slack_name}")
        Rails.logger.info(res)
      end
    end
  end
end