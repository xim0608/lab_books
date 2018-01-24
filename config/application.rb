require_relative 'boot'

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Labooks
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths << Rails.root.join("lib")
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'

    # config.middleware.insert_before 0, "Rack::Cors" do
    #   allow do
    #     origins '*'
    #     resource '*',
    #              :headers => :any,
    #              :expose => ['access-token', 'expiry', 'token-type', 'email', 'client'],
    #              :methods => [:get, :post, :options, :delete, :put]
    #   end
    # end
  end
end
