# frozen_string_literal: true

# app/controllers/square_webhooks_controller.rb
class SquareWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :handle_event

  def handle_event
    event_data = JSON.parse(request.body.read)

    # Log the event data to your Rails server log
    Rails.logger.info "Received Square webhook event: #{event_data}"
    # Enqueue the event_data for asynchronous processing with Sidekiq
    WebhookProcessor.perform_async(event_data)

    # Return an immediate response to Square (status code 200)
    head :ok
  rescue JSON::ParserError => e
    # Handle any JSON parsing errors that might occur
    Rails.logger.error "Error parsing JSON data: #{e.message}"
    # Return an error response to Square (status code 400)
    head :bad_request
  end
end
