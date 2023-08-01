# frozen_string_literal: true

# spec/controllers/square_webhooks_controller_spec.rb
require 'rails_helper'

RSpec.describe SquareWebhooksController, type: :controller do
  describe 'POST #handle_event' do
    it 'returns status code 200 for a valid webhook event' do
      post :handle_event, body: square_webhook_data.to_json

      expect(response).to have_http_status(:ok)
    end

    it 'enqueues the event data for asynchronous processing with Sidekiq' do
      expect do
        post :handle_event, body: square_webhook_data.to_json
      end.to change(WebhookProcessor.jobs, :size).by(1)
    end

    it 'logs the received event data' do
      expect(Rails.logger).to receive(:info).with("Received Square webhook event: #{square_webhook_data}")

      post :handle_event, body: square_webhook_data.to_json
    end

    it 'returns status code 400 for invalid JSON data' do
      post :handle_event, body: 'Invalid JSON Data'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns status code 400 for unrecognized event type' do
      invalid_event_data = { type: 'unknown_event_type' }
      post :handle_event, body: invalid_event_data.to_json

      expect(response).to have_http_status(:bad_request)
    end
  end

  # Helper method to generate sample webhook data
  def square_webhook_data
    {
      type: 'catalog.version.updated',
      data: {
        object: {
          catalog_version: {
            updated_at: '2023-08-01T15:53:41.389Z'
          }
        }
      }
    }
  end
end
