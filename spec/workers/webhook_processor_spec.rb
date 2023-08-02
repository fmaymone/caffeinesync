# frozen_string_literal: true

# spec/workers/webhook_processor_spec.rb
require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe WebhookProcessor, type: :worker do
  let(:update_event_data) do
    {
      'type' => 'catalog.version.updated',
      'data' => {
        'object' => {
          'catalog_version' => {
            'updated_at' => '2023-08-01T15:53:41.389Z'
          }
        }
      }
    }
  end

  let(:create_event_data) do
    {
      'type' => 'catalog.version.created',
      'data' => {
        'object' => {
          'catalog_version' => {
            'updated_at' => '2023-08-01T15:53:41.389Z'
          }
        }
      }
    }
  end

  it 'calls CatalogVersionCreatedHandler when event type is catalog.version.created' do
    expect(CatalogVersionCreatedHandler).to receive(:handle).with(create_event_data)
    WebhookProcessor.perform_async(create_event_data)
  end

  it 'calls CatalogVersionUpdatedHandler when event type is catalog.version.updated' do
    expect(CatalogVersionUpdatedHandler).to receive(:handle).with(update_event_data)
    WebhookProcessor.perform_async(update_event_data)
  end

  it 'logs a warning for unrecognized event type' do
    update_event_data['type'] = 'unrecognized_event'
    expect(Rails.logger).to receive(:warn).with('Unrecognized event type: unrecognized_event')
    WebhookProcessor.perform_async(update_event_data)
  end

  it 'logs an error for StandardError' do
    allow(CatalogVersionUpdatedHandler).to receive(:handle).and_raise(StandardError, 'Something went wrong')
    expect(Rails.logger).to receive(:error).with('Error processing webhook event: Something went wrong')
    WebhookProcessor.perform_async(update_event_data)
  end
end
