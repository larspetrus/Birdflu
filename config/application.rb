require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Birdflu

  BOOTED_AT = Time.now

  class Application < Rails::Application

    config.cache_store = :memory_store

    # Zeitwerk: collapse non-conventional model directories so files define
    # top-level constants (e.g. app/models_poro/algs.rb defines Algs, not ModelsPoro::Algs)
    config.autoload_paths.each do |path|
      Rails.autoloaders.main.collapse(path) if path.match?(%r{/app/models_})
    end

    # Monkey patched in config/initializers/birdflu_log_formatter.rb
    if ENV['RAILS_LOG_TO_STDOUT'].present?
      config.logger = ActiveSupport::Logger.new($stdout)
    else
      config.logger = ActiveSupport::Logger.new(config.paths['log'].first, 2, 10.megabytes)
    end
    config.log_level = :debug

    # From https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = self.routes

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
