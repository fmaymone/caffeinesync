# frozen_string_literal: true

# spec/models/event_spec.rb
require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '.last_synced_timestamp' do
    it 'returns nil if no events exist' do
      expect(Event.last_synced_timestamp).to be_nil
    end

    it 'returns the created_at timestamp of the latest event' do
      event1 = create(:event, source: 'Square', created_at: 1.hour.ago)
      create(:event, source: 'Square', created_at: 2.hours.ago)
      expect(Event.last_synced_timestamp).to eq(event1.created_at)
    end
  end

  describe 'validations' do
    # ... existing validation tests ...

    it 'allows valid sources' do
      Event::SOURCES.each do |source|
        event = build(:event, source:)
        expect(event).to be_valid
      end
    end
  end

  describe '.last_synced_timestamp_by_source' do
    it 'returns nil if no events with the provided source exist' do
      expect(Event.last_synced_timestamp_by_source('InvalidSource')).to be_empty
    end

    it 'returns the created_at timestamp of the latest event with the provided source' do
      event1 = create(:event, source: 'Shopify', created_at: 1.hour.ago)
      event2 = create(:event, source: 'Square', created_at: 2.hours.ago)

      expect(Event.last_synced_timestamp_by_source('Shopify')).to eq(event1.created_at)
      expect(Event.last_synced_timestamp_by_source('Square')).to eq(event2.created_at)
    end

    it 'ignores events with different sources' do
      event1 = create(:event, source: 'Shopify', created_at: 1.hour.ago)
      create(:event, source: 'Square', created_at: 2.hours.ago)

      expect(Event.last_synced_timestamp_by_source('Shopify')).to eq(event1.created_at)
    end
  end
end
