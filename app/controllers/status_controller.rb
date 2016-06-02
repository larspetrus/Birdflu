class StatusController < ApplicationController
  def index
    @ruby_version = "#{RUBY_VERSION} patch #{RUBY_PATCHLEVEL} platform #{RUBY_PLATFORM}"
  end
end
