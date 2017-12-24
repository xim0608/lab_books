set :stage, :production
set :branch, 'master'

role :app, %w{localhost}
role :web, %w{localhost}
role :db, %w{localhost}
