# -*- coding: utf-8 -*-
worker_processes 4

app_path = '/var/www/labooks'
app_shared_path = "#{app_path}/shared"
working_directory '/var/www/labooks/current'

listen "#{app_shared_path}/tmp/sockets/unicorn.sock"
pid "#{app_shared_path}/tmp/pids/unicorn.pid"

timeout 30

stderr_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])
preload_app true

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{working_directory}/Gemfile"
end

before_fork do |server, worker|
  # http://techracho.bpsinc.jp/baba/2012_08_29/6001
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!

  # 古いPIDファイル取得
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    # 古いPIDがある場合
    begin
      # 古いmasterプロセスを終了させる
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end

# after_fork do |server, worker|
#   Signal.trap 'TERM' do
#     puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
#   end
#
#   defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
# end
