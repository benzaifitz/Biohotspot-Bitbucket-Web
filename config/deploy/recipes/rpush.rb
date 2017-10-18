require 'mina/bundler'

namespace :rpush do
  set :rpush_command, -> { "cd #{fetch(:current_path)} && bundle exec rpush" }

  desc 'Start rpush'
  task start: :environment do
    command %[echo '-----> Starting rpush']
    command "#{fetch(:rpush_command)} start -e #{fetch(:rails_env)}"
  end

  desc 'Stop rpush'
  task stop: :environment do
    command %[echo '-----> Stopping rpush']
    # command "kill -9 $(ps ax | grep rpush | fgrep -v grep | awk '{ print $1 }')"
    command "if (ps ax | grep rpush | fgrep -v grep | awk '{ print $1 }') ; then kill -9 $(ps ax | grep rpush | fgrep -v grep | awk '{ print $1 }') ; fi"
  end

  desc 'Restart rpush'
  task restart: :environment do
    command %[echo '-----> Restarting rpush']
    command "#{fetch(:rpush_command)} stop -e #{fetch(:rails_env)}; #{fetch(:rpush_command)} start -e #{fetch(:rails_env)}"
  end

  desc 'Push pending notifications'
  task push: :environment do
    command %[echo '-----> Pushing pending notifications']
    command "#{fetch(:rpush_command)} push -e #{fetch(:rails_env)}"
  end

  desc 'Check rpush status'
  task status: :environment do
    command %[echo '-----> Checking rpush status']
    command "#{fetch(:rpush_command)} status -e #{fetch(:rails_env)}"
  end
end
