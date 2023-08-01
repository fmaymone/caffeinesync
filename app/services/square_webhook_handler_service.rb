# frozen_string_literal: true

# app/services/square_webhook_handler_service.rb
class SquareWebhookHandlerService
  def initialize(event_data)
    @event_data = event_data
    initialize_square_client
  end

  def process_webhook_event
    unless @event_data['type'] == 'catalog.version.created' || @event_data['type'] == 'catalog.version.updated'
      return false
    end

    updated_at = if Event.last_synced_timestamp_by_source('Shopify').nil?
                   DateTime.new(2010, 1, 1) # this is for the first processing. I get a very old data to make sure it sync
                 else
                   Event.last_synced_timestamp_by_source('Shopify').created_at
                 end
    objects = retrieve_catalog_objects(updated_at)

    return false unless objects

    process_objects(objects)

    true
  rescue StandardError => e
    Rails.logger.error "Error processing Square webhook event: #{e.message}"
    false
  end

  private

  def initialize_square_client
    @square_client = Square::Client.new(
      access_token: ENV.fetch('SQUARE_ACCESS_TOKEN_SANDBOX'),
      environment: 'sandbox',
      timeout: 1
    )
  end

  def retrieve_catalog_objects(begin_time)
    response = @square_client.catalog.search_catalog_objects(
      body: {
        begin_time:
      }
    )

    return response.data.objects if response.success?

    Rails.logger.error "Failed to retrieve catalog object: #{response.errors}"
    nil
  end

  def process_objects(objects)
    # Wrap the creation of new events in a database transaction for batch processing
    Event.transaction do
      objects.each do |object|
        # Customize the payload as needed for the event
        payload = {
          type: @event_data['type'],
          data: {
            object:
          }
        }
        # Create a new Event record
        Event.create!(source: 'Square', external_id: object[:id], payload:)
      end
    end
  end
end
