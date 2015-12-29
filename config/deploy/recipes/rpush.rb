namespace :rpush do
  %w[stop start].each do |command|
    desc "#{command} rpush"
    task command do
      on roles(:web), in: :sequence, wait: 1 do
        run "rpush #{command}"
      end
    end
  end
  after "deploy:restart", 'rpush:stop'
  after "deploy:restart", 'rpush:start'
end