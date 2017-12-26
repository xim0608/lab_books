require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
# reference => https://qiita.com/komazarari/items/d227ecc331f2a91bd7ca
require 'capistrano/locally'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/rbenv'
require 'capistrano3/unicorn'

set :rbenv_type, :system
set :rbenv_path, '/usr/local/rbenv'
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
