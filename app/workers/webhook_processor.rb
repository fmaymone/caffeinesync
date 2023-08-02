# frozen_string_literal: true

# app/workers/webhook_processor.rb
class WebhookProcessor
  include Sidekiq::Worker

  def perform(event_data)
    # Process the webhook event data
    # Determine the event type and call the appropriate handler
    event_type = event_data['type']
    case event_type
    when 'catalog.version.created'
      CatalogVersionCreatedHandler.handle(event_data)
    when 'catalog.version.updated'
      CatalogVersionUpdatedHandler.handle(event_data)
    else
      Rails.logger.warn "Unrecognized event type: #{event_type}"
    end
  rescue StandardError => e
    Rails.logger.error "Error processing webhook event: #{e.message}"
  end
end
