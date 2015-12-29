after :finished, :restart_rpush do
  on roles(:web) do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :bundle, :exec, "rpush stop -e #{fetch(:rails_env)}"
        execute :bundle, :exec, "rpush start -e #{fetch(:rails_env)}"
      end
    end
  end
end