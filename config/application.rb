require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Birdflu

  BOOTED_AT = Time.now

  class Application < Rails::Application

    config.cache_store = :memory_store

    # Monkey patched in config/initializers/birdflu_log_formatter.rb
    config.logger = ActiveSupport::Logger.new(config.paths['log'].first, 2, 10.megabytes)
    config.log_level = :debug

    # From https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = self.routes

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
