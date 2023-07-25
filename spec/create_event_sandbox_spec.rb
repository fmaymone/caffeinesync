require 'rails_helper'
require 'securerandom'
require 'square'

RSpec.describe 'Creating Event on Square Sandbox API' do

  fake_item_params = {
    name: 'Fake Item',
    description: 'This is a fake item for testing purposes',
    sku: SecureRandom.hex(6).upcase,
    variations: [
      {
        name: 'Default Variation',
        pricing_type: 'FIXED_PRICING',
        price_money: {
          amount: 100, 
          currency: 'USD'
        },
        type: 'ITEM_VARIATION',
        id: '#AMAZING_VARIATION',
        item_variation_data: {
          available_for_booking: true,
          pricing_type: "FIXED_PRICING",
          price_money: {
            amount: 100,
            currency: "USD"
          },
        }
      }
    ],
    visibility: 'PRIVATE' # 'PRIVATE' visibility ensures it's only visible to your application
  }
  describe 'validations' do
    describe 'it validates name' do
      client = Square::Client.new(
        access_token: ENV.fetch('SQUARE_ACCESS_TOKEN_SANDBOX'),
        environment: 'sandbox',
        timeout: 1
      )

      begin
        # Upsert the catalog object (item) to the Square Sandbox
        response = client.catalog.upsert_catalog_object(
          body: {
            idempotency_key: SecureRandom.uuid,
            object: {
              type: 'ITEM',
              id: '#MY_COFFEE',
              item_data: fake_item_params
            }
          }
        )
      
        if response.success?
          #puts "Fake item created successfully with ID: #{response.data['id']}"
        else
          puts 'Failed to create fake item:'
          puts response.errors
        end
      rescue StandardError => e
        puts 'Error occurred while creating the fake item:'
        puts e.message
      end
    end
  end
end