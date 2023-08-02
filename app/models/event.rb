# frozen_string_literal: true

class Event < ApplicationRecord
  SOURCES = %w[Shopify Square].freeze
  validates :source, presence: true, inclusion: { in: SOURCES }

  def self.last_synced_timestamp_by_source(source)
    # Find the latest created_at timestamp from the events table for the given source.
    # This will give us the last synced timestamp for that source.
    last_event = where(source:).order(:created_at).last
    last_event&.created_at
  end
end
