# spec/controllers/square_webhooks_controller_spec.rb
require 'rails_helper'

RSpec.describe SquareWebhooksController, type: :controller do
  describe '#handle_event' do
    let(:valid_event_data) { { 'type' => 'catalog.version.created', 'data' => {} }.to_json }
    let(:invalid_event_data) { 'invalid_json_data' }

    it 'enqueues the event_data for processing with Sidekiq' do
      expect(WebhookProcessor).to receive(:perform_async).with(JSON.parse(valid_event_data))
      post :handle_event, body: valid_event_data, as: :json
    end

    it 'logs an error for JSON parsing errors and returns 400 status' do
      expect(Rails.logger).to receive(:error).with(/Error parsing JSON data:/)
      post :handle_event, body: invalid_event_data, as: :json
      expect(response).to have_http_status(:bad_request)
    end
  end
end
