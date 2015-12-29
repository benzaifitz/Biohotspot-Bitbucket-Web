namespace :deploy do
  task :rpush_start do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "rpush start -e #{fetch(:rails_env)}"
        end
      end
    end
  end
  task :rpush_stop do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "rpush stop -e #{fetch(:rails_env)}"
        end
      end
    end
  end
  after 'deploy:restart', 'deploy:rpush_stop'
  after 'deploy:restart', 'deploy:rpush_start'
end
