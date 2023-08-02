# frozen_string_literal: true

# app/handlers/catalog_version_updated_handler.rb
class CatalogVersionUpdatedHandler < BaseHandler
  def handle
    # Process the event_data for catalog.version.updated
    webhook_handler = SquareWebhookHandlerService.new(@event_data)
    webhook_handler.process_webhook_event
  end
end
