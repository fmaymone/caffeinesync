# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:source) }
    it { should validate_inclusion_of(:source).in_array(Event::SOURCES) }
  end

  describe '.last_synced_timestamp_by_source' do
    let!(:shopify_event1) { FactoryBot.create(:event, source: 'Shopify', created_at: 1.day.ago) }
    let!(:shopify_event2) { FactoryBot.create(:event, source: 'Shopify', created_at: 3.hours.ago) }
    let!(:square_event1) { FactoryBot.create(:event, source: 'Square', created_at: 2.days.ago) }
    let!(:square_event2) { FactoryBot.create(:event, source: 'Square', created_at: 1.hour.ago) }

    it 'returns the last synced timestamp for the given source' do
      expect(Event.last_synced_timestamp_by_source('Shopify')).to eq(shopify_event2.created_at)
      expect(Event.last_synced_timestamp_by_source('Square')).to eq(square_event2.created_at)
    end

    it 'returns nil for an unknown source' do
      expect(Event.last_synced_timestamp_by_source('UnknownSource')).to be_nil
    end
  end
end
