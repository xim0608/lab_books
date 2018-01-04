source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'acts-as-taggable-on', '~> 5.0'
gem 'amazon-ecs', '~> 2.5.0'
gem 'annotate', '~> 2.6.5'
gem 'bcrypt', '~> 3.1.7'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.3.0'
gem 'devise_invitable'
gem 'devise_token_auth'
gem 'dotenv-rails', '~> 2.2.1'
gem 'google-api-client', '~> 0.11.3'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.3.1'
gem 'jwt', '~> 1.5.6'
gem 'kakurenbo-puti'
gem 'material_icons', '~> 2.2.1'
gem 'materialize-sass', '~> 0.98.2'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'okura', '~> 0.0.1'
gem 'puma', '~> 3.7'
gem 'rack-cors'
gem 'rails', '5.1.1'
gem 'rails-i18n'
gem 'rake', '10.4.2'
gem 'sass-rails', '~> 5.0'
gem 'search_cop', '~> 1.0.8'
gem 'slack-api'
gem 'therubyracer'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'
gem 'unicorn-worker-killer'
gem 'will_paginate', '~> 3.1.5'
gem 'will_paginate-materialize', github: 'harrybournis/will_paginate-materialize'
gem 'xmlrpc'
gem 'vuejs-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'better_errors', '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'byebug', '~> 9.0.6'
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-locally', require: false
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'onkcop', require: false
  gem 'rspec-rails', '~> 3.5.2'
end

group :development do
  gem 'bullet', '~> 5.5.1'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring', '~> 2.0.1'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '~> 2.14.0'
  gem 'database_cleaner', '~> 1.5.3'
  gem 'faker', '~> 1.7.3'
  gem 'launchy', '~> 2.4.3'
  gem 'selenium-webdriver', '~> 3.4.0'
end
