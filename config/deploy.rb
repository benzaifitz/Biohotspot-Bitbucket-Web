# config valid only for Capistrano 3.1
lock '3.7.1'
load 'config/deploy/recipes/redis.rb'
# load 'config/deploy/recipes/rpush.rb'
# load 'config/deploy/recipes/run_tests.rb'
set :application, 'pilbara-weed-management-web'
set :repo_url, 'git@bitbucket.org:applabsservice/pilbara-weed-management-web.git'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/ubuntu/pilbara-weed-management-web'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }


set :stages, %w(staging production)

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
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads public/stock_content}

# set :sidekiq_config, 'config/sidekiq.yml'

set :passenger_restart_with_touch, true
set :user, "ubuntu"
set :use_sudo, true
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
# set up sidekiq_role
# set :sidekiq_role, :app
# set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
# sed :sidekiq_queue
# set :sidekiq_queue, ['default', 'mailchimp', 'rpush_notifications']
# set :sidekiq_queue, ['default', 'mailchimp']
# set :sidekiq_pid, File.join(shared_path, 'tmp', 'sidekiq.pid')
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
