require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fram
  class Application < Rails::Application
    #config.generators do |g|
    #  g.helper false
    #  g.javascript_engine false
    #  g.stylesheets false
    #  g.test_framework :rspec,
    #    fixtures: true,
    #    view_specs: false,
    #    helper_specs: false,
    #    routing_specs: false,
    #    controller_specs: true,
    #    request_specs: false
    #  g.fixture_replacement :factory_girl, dir: "spec/factories"
    #end
    
    #config.middleware.use Rack::Cors do
    #  allow do
    #    origins '*'
    #    resource '*',
    #      :headers => :any,
    #      :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
    #      :methods => [:get, :post, :options, :delete, :put]
    #  end
    #end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.assets.precompile += ['active_admin.css', 'active_admin.js']
    # Do not swallow errors in after_commit/after_rollback callbacks.
    #config.active_record.raise_in_transactional_callbacks = true
    # Setup sidkiq to be used for delayed jobs
    #config.active_job.queue_adapter = :sidekiq
    # Setup autoload for lib
    config.autoload_paths += Dir["#{Rails.root}/lib"]
  end
end
