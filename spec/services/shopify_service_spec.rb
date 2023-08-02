# frozen_string_literal: true

require 'rails_helper'
require 'shopify_api'
# require_relative '../../app/services/shopify_service'

RSpec.describe ShopifyService do
  describe '#fetch_inventory_items' do
    # let(:mock_inventory_items) do
    #   [
    #     double('Variant', sku: 'ABC123', title: 'Product 1', inventory_quantity: 10),
    #     double('Variant', sku: 'DEF456', title: 'Product 2', inventory_quantity: 5),
    #     double('Variant', sku: 'GHI789', title: 'Product 3', inventory_quantity: 20)
    #   ]
    # end
    # before do
    #   # Stub ShopifyAPI::Base.site to prevent actual API calls in tests
    #   allow(ShopifyAPI::Base).to receive(:site)
    # end

    it 'returns all inventory items' do
      # allow(ShopifyAPI::Variant).to receive(:find).and_return(mock_inventory_items)
      #ShopifyService.fetch_inventory_items
      # ShopifyAPI::Variant.find(:all, params: { limit: 250, page: 1 })
      # inventory_items = ShopifyAPI::Variant.find(:all, params: { limit: 250, page: 1 })
    end
  end
end
