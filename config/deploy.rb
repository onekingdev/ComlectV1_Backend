# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :branch, ENV['REVISION'] || ENV['BRANCH_NAME']

set :application, 'complect'
set :repo_url, 'git@github.com:complectco/complect.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, '/var/www/complect'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  desc 'Create symlink'
  task :symlink do
    on roles(:all) do
      # execute "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
      execute "ln -s #{shared_path}/Procfile #{release_path}/Procfile"
      # execute "ln -s #{shared_path}/system #{release_path}/public/system"
      # execute "ln -s #{shared_path}/uploads #{release_path}/public/uploads"

      # execute "ln -s #{shared_path}/data #{release_path}/public/data"
      # execute "ln -s #{shared_path}/uploads #{release_path}/public/uploads"

      # execute "mkdir #{release_path}/tmp"
      # execute "ln -s #{shared_path}/pids #{release_path}/tmp/pids"
      # execute "ln -s #{shared_path}/log #{release_path}/log"
    end
  end

  after :updating, 'deploy:symlink'

  after :publishing, :restart

  task :restart do
    invoke 'unicorn:reload'
  end
end
