# frozen_string_literal: true

# spec/factories/events.rb
FactoryBot.define do
  factory :event do
    payload { { key: 'value' } }
  end
end
