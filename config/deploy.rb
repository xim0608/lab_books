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
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
set :bundle_flags, "--deployment --without development test"
set :keep_releases, 5
set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  # # アプリの再起動を行うタスク
  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute :mkdir, '-p', release_path.join('tmp')
  #     execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end

  # linked_files で使用するファイルをアップロードするタスク
  # deployが行われる前に実行する必要がある。
  desc 'upload important files'
  task :upload do
    on roles(:app) do |host|
      execute :mkdir, '-p', "#{shared_path}/config"
      upload!('config/database.yml',"#{shared_path}/config/database.yml")
      upload!('config/secrets.yml',"#{shared_path}/config/secrets.yml")
    end
  end

  # webサーバー再起動時にキャッシュを削除する
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rm, '-rf', release_path.join('tmp/cache')
      end
    end
  end

  # Flow の before, after のタイミングで上記タスクを実行
  # before :started, 'deploy:upload'
  after :finishing, 'deploy:cleanup'

  # Unicorn 再起動タスク
  # desc 'Restart application'
  # task :restart do
  #   invoke 'unicorn:restart' # lib/capistrano/tasks/production.rake 内処理を実行
  # end
end

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
