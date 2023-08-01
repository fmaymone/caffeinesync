# frozen_string_literal: true

# spec/factories/events.rb
FactoryBot.define do
  factory :event do
    title { 'Test Event' }
    description { 'Test description' }
    payload { { key: 'value' } }
  end
end
