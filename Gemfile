source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '5.1.1'


gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails', '~> 4.3.1'
gem 'turbolinks', '~> 5.0.1'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'
gem 'annotate', '~> 2.6.5'
#gem 'capistrano-rails', group: :development
gem 'dotenv-rails', '~> 2.2.1'
gem 'omniauth', '~> 1.6.1'
gem 'omniauth-slack', '~> 2.3.0'
gem 'devise', '~> 4.3.0'
gem 'will_paginate', '~> 3.1.5'
gem 'google-api-client', '~> 0.11.3'
gem 'acts-as-taggable-on', '~> 5.0'
gem 'okura', '~> 0.0.1'
gem 'search_cop', '~> 1.0.8'
gem 'amazon-ecs', '~> 2.5.0'
gem 'materialize-sass', '~> 0.98.2'
gem 'material_icons', '~> 2.2.1'
gem 'will_paginate-materialize', '~> 0.1.0'
gem 'knock', '~> 2.1.1'
gem "bulma-rails"
gem 'will_paginate-bulma', '~> 1.0'
gem "font-awesome-rails", '~> 4.7.0.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.0.6'
  gem 'better_errors', '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'rspec-rails', '~> 3.5.2'
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'mysql2', '>= 0.3.18', '< 0.5'
end

group :staging do
  gem 'pg'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0.1'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'bullet', '~> 5.5.1'

end

group :test do
  gem 'faker', '~> 1.7.3'
  gem 'capybara', '~> 2.14.0'
  gem 'database_cleaner', '~> 1.5.3'
  gem 'launchy', '~> 2.4.3'
  gem 'selenium-webdriver', '~> 3.4.0'
end
