# frozen_string_literal: true

# spec/support/square_client_helper.rb
require 'square'

module SquareClientHelper
  def sandbox_square_client
    Square::Client.new(
      access_token: ENV.fetch('SQUARE_ACCESS_TOKEN_SANDBOX'),
      environment: 'sandbox',
      timeout: 1
    )
  end
end
