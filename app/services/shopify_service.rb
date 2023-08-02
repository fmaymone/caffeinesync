# frozen_string_literal: true

require 'shopify_api'

class ShopifyService
  # Replace these values with your actual Shopify store credentials
  API_KEY = ENV.fetch('SHOPIFY_ACCESS_CLIENT_ID')
  PASSWORD = ENV.fetch('SHOPIFY_ACCESS_CLIENT_SECRET')
  SHOP_NAME = ENV.fetch('SHOPIFY_SHOP_NAME')

  def self.fetch_inventory_items
    # url = "https://#{API_KEY}:#{PASSWORD}@#{SHOP_NAME}/admin/api/2020-01/products.json"
    # Initialize the Shopify API with your credentials
    ShopifyAPI::Context.setup(
      api_key: ENV.fetch('SHOPIFY_ACCESS_CLIENT_ID'),
      api_secret_key: ENV.fetch('SHOPIFY_ACCESS_CLIENT_SECRET'),
      host_name: ENV.fetch('SHOPIFY_SHOP_NAME'),
      scope: 'read_orders,read_products,etc',
      private_shop: ENV.fetch('SHOPIFY_SHOP_NAME'),
      is_embedded: false, # Set to true if you are building an embedded app
      is_private: true, # Set to true if you are building a private app
      api_version: '2023-07' # The version of the API you would like to use
    )
    session = ShopifyAPI::Auth::Session.new(shop: ENV.fetch('SHOPIFY_SHOP_NAME'),
                                            access_token: ENV.fetch('SHOPIFY_ACCESS_CLIENT_SECRET'))
    puts session.inspect

    client = ShopifyAPI::Clients::Rest::Admin.new(session:)
    client.get(path: 'orders',
               query: { created_at_min: '2023-05-01T00:59:59-08:00', created_at_max: '2023-07-18T23:59:59-08:00', status: 'any',
                        limit: 250 })
    debugger
  end
end
