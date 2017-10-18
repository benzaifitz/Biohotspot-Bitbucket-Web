require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/whenever'
require_relative 'deploy/recipes/redis'
require_relative 'deploy/recipes/rpush'
require_relative 'deploy/recipes/sidekiq'

set :domain, '13.54.208.193' # production
# set :domain, '52.64.75.81'  # staging
set :deploy_to, '/home/ubuntu/pilbara-weed-management-web'
set :repository, 'git@bitbucket.org:applabsservice/pilbara-weed-management-web.git'
set :branch, 'develop'
set :rails_env, 'production'
set :user, 'ubuntu'
set :forward_agent, true
set :identity_file, '~/.ssh/pwm.pem' #staging
# set :identity_file, '~/.ssh/pwm-production.pem' #production
# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
set :application_name, 'pilbara-weed-management-web'
set :shared_files, fetch(:shared_files, []).push('config/certs/distribution.pem', 'config/database.yml', 'config/secrets.yml', '.env')
set :shared_paths, fetch(:shared_paths, []).push('log','tmp', 'config/certs')

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
    invoke 'rpush:stop'
    on :launch do
      in_path(fetch(:current_path)) do
        invoke :'rvm:use', 'ruby-2.3.0@default'
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
        invoke :'whenever:update'
        invoke 'redis:restart'
        invoke 'rpush:start'
        invoke 'sidekiq:stop'
      end

    end
  end

end


