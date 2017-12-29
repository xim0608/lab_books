set :stage, :production
set :rails_env, :production
set :unicorn_rack_env, "production"
set :branch, 'master'

role :app, %w{localhost}
role :web, %w{localhost}
role :db, %w{localhost}
