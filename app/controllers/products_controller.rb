# frozen_string_literal: true

class ProductsController
  def index
    @products = ShopifyAPI::Product.all(limit: 10)
    render(json: { products: @products })
  end
end
