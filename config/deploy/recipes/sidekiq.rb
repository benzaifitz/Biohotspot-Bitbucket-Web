namespace :sidekiq do
  def sidekiq_pid
    current_path + '../shared/tmp/pids/sidekiq-0.pid'
  end

  def pid_file_exists?
    test(*("[ -f #{sidekiq_pid} ]").split(' '))
  end

  def pid_process_exists?
    pid_file_exists? and test(*("kill -0 $( cat #{sidekiq_pid} )").split(' '))
  end

  task :start do
    on roles(:app) do
      if !pid_process_exists?
        execute "cd #{current_path} && RAILS_ENV=#{fetch(:rails_env)} #{fetch(:rbenv_prefix)} bundle exec sidekiq -C config/sidekiq.yml -e #{fetch(:rails_env)} -L log/sidekiq.log -P #{sidekiq_pid} -d"
      end
    end
  end

  task :stop do
    on roles(:app) do
      if pid_process_exists?
        puts "++++++++++++++++"
        execute "kill `cat #{sidekiq_pid}`"
        execute "rm #{sidekiq_pid}"
      end
    end
  end

  task :restart do
    on roles(:app) do
      invoke "sidekiq:stop"
      invoke "sidekiq:start"
    end
  end
end

# after 'deploy:restart', 'sidekiq:stop'