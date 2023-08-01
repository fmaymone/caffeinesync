# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'
require 'square'

RSpec.describe 'Creating Event on Square Sandbox API' do
  fake_item_params = {
    name: 'Fake Item 2',
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
          pricing_type: 'FIXED_PRICING',
          price_money: {
            amount: 100,
            currency: 'USD'
          }
        }
      }
    ],
    visibility: 'PRIVATE' # 'PRIVATE' visibility ensures it's only visible to your application
  }

  describe 'insert items' do
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
          puts "Fake item created successfully with ID: #{response.data}"
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

  describe 'insert items with custom attributes' do
    client = Square::Client.new(
      access_token: ENV.fetch('SQUARE_ACCESS_TOKEN_SANDBOX'),
      environment: 'sandbox',
      timeout: 1
    )
    result = client.catalog.batch_upsert_catalog_objects(
      body: {
        idempotency_key: '{UNIQUE_KEY}',
        batches: [
          {
            objects: [
              {
                type: 'CUSTOM_ATTRIBUTE_DEFINITION',
                id: '#cocoa_brand',
                custom_attribute_definition_data: {
                  type: 'STRING',
                  name: 'Brand',
                  allowed_object_types: %w[
                    ITEM
                    ITEM_VARIATION
                  ],
                  key: 'cocoa_brand'
                }
              },
              {
                type: 'CUSTOM_ATTRIBUTE_DEFINITION',
                id: '#topping',
                custom_attribute_definition_data: {
                  type: 'SELECTION',
                  name: 'Tasting Notes',
                  allowed_object_types: %w[
                    ITEM
                    ITEM_VARIATION
                  ],
                  selection_config: {
                    max_allowed_selections: 5,
                    allowed_selections: [
                      {
                        uid: '#marshmallow',
                        name: 'Marshmallow'
                      },
                      {
                        uid: '#whipped_cream',
                        name: 'Whipped Cream'
                      }
                    ]
                  },
                  key: 'topping'
                }
              },
              {
                type: 'ITEM',
                id: '#hot-cocoa',
                custom_attribute_values: {
                  "cocoa_brand": {
                    "key": 'cocoa_brand',
                    "custom_attribute_definition_id": '#cocoa_brand',
                    "name": 'Brand',
                    "type": 'STRING',
                    "string_value": 'Cocoa Magic'
                  }
                },
                item_data: {
                  name: 'Hot Cocoa',
                  variations: [
                    {
                      type: 'ITEM_VARIATION',
                      id: '#hot-cocoa-small',
                      custom_attribute_values: {
                        "topping": {
                          "key": 'topping',
                          "custom_attribute_definition_id": '#topping',
                          "name": 'Tasting Notes',
                          "type": 'SELECTION',
                          "selection_uid_values": [
                            '#marshmallow',
                            '#whipped-cream'
                          ]
                        }
                      },
                      item_variation_data: {
                        name: 'Small',
                        pricing_type: 'FIXED_PRICING',
                        price_money: {
                          amount: 500,
                          currency: 'USD'
                        }
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }
    )

    if result.success?
      puts result.data
    elsif result.error?
      warn result.errors
    end
  end
end
