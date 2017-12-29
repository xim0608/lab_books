require 'devise/version'
require 'slack'
require 'action_view/helpers/sanitize_helper'

module DeviseInvitable
  module Mailer

    # Deliver an invitation email
    def invitation_instructions(record, token, opts={})
      # devise_mail(record, :invitation_instructions, opts)
    end
  end
end
