# app/controllers/square_webhooks_controller.rb
class SquareWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :handle_event

  # This action will handle incoming webhook events from Square
  def handle_event
    # Retrieve the entire request payload (JSON data) from Square
    event_data = JSON.parse(request.body.read)

    # Log the event data to your Rails server log
    Rails.logger.info "Received Square webhook event: #{event_data}"

    # Your webhook event handling logic goes here
    # Depending on the event type, you can perform specific actions in response to the webhook
    # For example, you might want to update your application's data or trigger other processes.

    # Return a successful response to Square (status code 200)
    head :ok
  rescue JSON::ParserError => e
    # Handle any JSON parsing errors that might occur
    Rails.logger.error "Error parsing JSON data: #{e.message}"
    # Return an error response to Square (status code 400)
    head :bad_request
  end
end

