require 'mina/deploy'
require 'mina/install'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
set :domain, '54.206.115.78'
set :deploy_to, '/home/ubuntu/pilbara-weed-management-web'
set :repository, 'git@bitbucket.org:applabsservice/pilbara-weed-management-web.git'
set :branch, 'master'
set :rails_env, 'production'
set :user, 'ubuntu'
set :forward_agent, true
set :identity_file, '~/.ssh/pwm.pem'
# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
set :application_name, 'pilbara-weed-management-web'
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml', '.env')

# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# set :shared_dirs, fetch(:shared_dirs, []).push('somedir')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rvm:use', 'ruby-2.3.0@default'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.3.0}
end

desc "Deploys the current version to the server."
task :'deploy' do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
        invoke :'redis:restart'
        invoke :'deploy:restart'
      end
    end
  end

end

namespace :redis do
  desc "Install the latest release of Redis"
  task :install do
    on roles(:app) do
      run "#{sudo} add-apt-repository ppa:chris-lea/redis-server", :pty => true do |ch, stream, data|
        press_enter(ch, stream, data)
      end
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install redis-server"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} redis"
    task command do
      on roles(:web), in: :sequence, wait: 1 do
        # run "#{sudo} service redis-server #{command}"
        execute :sudo, "nohup service redis-server #{command}"
      end
    end
  end
end

namespace :deploy do
  task :rpush_restart do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          if test("[ -f #{release_path}/tmp/pids/rpush.pid ]")
            execute :bundle, :exec, "rpush stop -e #{fetch(:rails_env)}"
          end
          execute :bundle, :exec, "rpush start -e #{fetch(:rails_env)}"
        end
      end
    end
  end
end
