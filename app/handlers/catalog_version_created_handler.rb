# frozen_string_literal: true

# app/handlers/catalog_version_created_handler.rb
class CatalogVersionCreatedHandler < BaseHandler
  def handle
    # Process the event_data for catalog.version.created
    # Your specific logic here
    webhook_handler = SquareWebhookHandlerService.new(@event_data)
    webhook_handler.process_webhook_event
  end
end
