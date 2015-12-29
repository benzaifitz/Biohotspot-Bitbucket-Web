namespace :rpush do
  task :restart do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          if test("[ -f #{shared_path}/tmp/rpush.pid ]")
            execute :bundle, :exec, "rpush stop -e #{fetch(:rails_env)}"
          end
          execute :bundle, :exec, "rpush start -e #{fetch(:rails_env)}"
        end
      end
    end
  end
  after 'deploy:restart', 'rpush:restart'
end
