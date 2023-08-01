# frozen_string_literal: true

# spec/handlers/base_handler_spec.rb
require 'rails_helper'

RSpec.describe BaseHandler do
  let(:event_data) do
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

  describe '.handle' do
    it 'raises NotImplementedError' do
      expect { BaseHandler.handle(event_data) }.to raise_error(NotImplementedError)
    end
  end

  describe '#initialize' do
    it 'initializes with event_data' do
      handler = BaseHandler.new(event_data)
      expect(handler.instance_variable_get(:@event_data)).to eq(event_data)
    end
  end

  describe '#handle' do
    it 'raises NotImplementedError' do
      handler = BaseHandler.new(event_data)
      expect { handler.handle }.to raise_error(NotImplementedError)
    end
  end
end
