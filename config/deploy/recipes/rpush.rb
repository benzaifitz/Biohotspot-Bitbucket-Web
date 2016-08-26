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

after 'deploy:restart', 'deploy:rpush_restart'
