# config valid only for Capistrano 3.1
lock '3.1.0'
load 'config/deploy/recipes/redis.rb'
load 'config/deploy/recipes/rpush.rb'
load 'config/deploy/recipes/run_tests.rb'
set :application, 'framework'
set :repo_url, 'git@bitbucket.org:applabsservice/framework.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/ubuntu/framework'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml .env}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :sidekiq_config, 'config/sidekiq.yml'
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
# set up sidekiq_role
set :sidekiq_role, :app
# set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
set :sidekiq_env, 'production'
# sed :sidekiq_queue
set :sidekiq_queue, ['default', 'mailchimp', 'rpush_notifications']
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'tmp:cache:clear'
      end
    end
  end

end
