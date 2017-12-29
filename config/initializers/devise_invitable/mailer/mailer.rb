require 'devise/version'
require 'slack'
require 'action_view/helpers/sanitize_helper'

module DeviseInvitable
  module Mailer

    # Deliver an invitation email
    def invitation_instructions(record, token, opts={})
      @token = token
      slack_user = record.email.split('@')[1]
      @resource = record
      text = ERB.new(File.read("#{Rails.root}/app/views/devise/mailer/invitation_instructions.text.erb")).result(binding)
      res = Slack.chat_postMessage(text: text, username: 'labooks', channel: "@#{slack_user}")
      Rails.logger.info(res)
      # devise_mail(record, :invitation_instructions, opts)
    end
  end
end
