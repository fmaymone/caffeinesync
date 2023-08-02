# frozen_string_literal: true

# spec/services/square_webhook_handler_service_spec.rb
require 'rails_helper'
require_relative '../support/square_mock_data'

RSpec.describe SquareWebhookHandlerService, type: :service do
  let(:event_data) { { 'type' => 'catalog.version.created', 'data' => {} } }
  let(:square_objects) { square_mock_data }

  describe '#initialize' do
    it 'initializes the SquareWebhookHandlerService with event_data' do
      service = SquareWebhookHandlerService.new(event_data)
      expect(service.instance_variable_get(:@event_data)).to eq(event_data)
    end
  end
  describe '#process_webhook_event' do
    let(:service) { SquareWebhookHandlerService.new(event_data) }

    before do
      # Mock the retrieve_catalog_objects method to return square_objects
      allow_any_instance_of(SquareWebhookHandlerService).to receive(:retrieve_catalog_objects).and_return(square_objects)
    end

    it 'processes webhook event with mock data' do
      expect(service.process_webhook_event).to eq(true)
      expect(Event.all.size).to eq(2)
    end
  end
end
