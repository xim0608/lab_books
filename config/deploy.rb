# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "labooks"
set :repo_url, "https://github.com/xim0608/labooks.git"
set :branch, 'master'
set :deploy_to, '/var/www/labooks'
set :scm, :git
set :log_level, :debug
set :pty, true
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets bundle public/system public/assets}
set :default_env, {path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"}
set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
end
