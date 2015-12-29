namespace :deploy do
  desc "Runs specs before deploying, can't deploy unless they pass."
  task :run_tests do
    test_log = "log/capistrano.spec.log"
    puts '--> Running specs: please wait ...'
    unless system "bundle exec rspec spec > #{test_log} 2>&1"
      puts "--> Specs failed. Results in: #{test_log} and below:"
      system "cat #{test_log}"
      exit;
    end
    puts '--> All specs passed'
    system "rm #{test_log}"
  end
  before :deploy, "deploy:run_tests"
end