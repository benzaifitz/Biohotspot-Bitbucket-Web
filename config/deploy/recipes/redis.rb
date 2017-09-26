# set_default(:redis_pid, "/var/run/redis/redis-server.pid")
# set_default(:redis_port, 6379)
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
  after "deploy:restart", 'redis:restart'
end