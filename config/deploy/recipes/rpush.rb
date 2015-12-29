namespace :deploy do
  task :rpush_restart do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          if File.exist?("#{shared_path}/tmp/rpush.pid")
            puts "===================1"
            execute :bundle, :exec, "rpush stop -e #{fetch(:rails_env)}"
          end
          puts "===================2"
          execute :bundle, :exec, "rpush start -e #{fetch(:rails_env)}"
        end
      end
    end
  end
  after 'deploy:restart', 'deploy:rpush_restart'
end
