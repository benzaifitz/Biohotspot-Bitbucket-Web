source 'https://rubygems.org'
ruby '2.3.0'
gem 'rails', '5.0.0'
gem 'pg'
gem 'sass-rails', '>= 5.0.6'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.1'
gem 'jquery-rails', '>= 4.2.1'
gem 'jbuilder', '>= 2.6.0'
gem 'annotate', '>= 2.7.1'
gem 'inherited_resources', github: 'activeadmin/inherited_resources'
gem 'activeadmin', '~> 1.0.0.pre4' #github: 'activeadmin'
gem 'paper_trail', '~> 4.0.0'
gem 'dotenv-rails', '>= 2.1.1'
# MailChimp integration
gem 'gibbon'
# The push notification service.
gem 'rpush'
group :development, :test do
  gem 'byebug'
end
group :development do
  #gem 'web-console', '~> 2.0' # Dont and caused Rails 5 problem
  gem 'spring'
  gem 'letter_opener'
end
gem 'apipie-rails'
gem 'devise'
gem 'high_voltage', '~> 2.4.0'
gem 'simple_form','>= 3.3.1'
gem 'rack-cors', :require => 'rack/cors'
gem 'omniauth', '>= 1.3.1'
gem 'devise_token_auth', '>= 0.1.39'
gem 'sidekiq', '>= 4.2.2'
gem 'ckeditor', '~> 4.1', '>= 4.1.5'
gem 'socket.io-client-simple'
gem 'houston'
gem 'fancybox-rails', '~> 0.3.0'

gem 'mini_magick', '~> 4.3', '>= 4.3.6'
gem 'carrierwave', '~> 0.10.0'
gem 'fog', '~> 1.36'

#gem 'responders'
group :development do
  gem 'better_errors'
  #gem 'quiet_assets','>= 1.1.0' # No compatible version
  gem 'rails_layout'
  gem 'spring-commands-rspec'
  gem 'capistrano', '~> 3.7.0'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-rvm', github: "capistrano/rvm"
  gem 'capistrano-sidekiq'
  gem 'rest-client'
  gem 'puma'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  #gem 'rspec'
  # gem 'fakeredis'
  gem 'rspec-rails', '~> 3.5.2'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'shoulda-callback-matchers', '~> 1.1.1'
  gem 'redis-namespace'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end
gem 'sinatra', :require => nil #may re-enable it