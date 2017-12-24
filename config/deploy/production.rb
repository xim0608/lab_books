set :rails_env, 'production'
set :unicorn_rack_env, 'production'

server 'localhost', roles: %{app web db}
