class ErrorsController < ApplicationController
  def not_found
    @request_url = request&.original_url
    logger.warn("Showing 404 page for '#{@request_url}'")
    render(:status => 404)
  end

  def internal_server_error
    @request_url = request&.original_url
    logger.warn("Showing 500 page for '#{@request_url}'")
    render(:status => 500)
  end
end
