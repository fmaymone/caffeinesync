# frozen_string_literal: true

require 'rails_helper'
require 'square'

RSpec.describe 'Testing Square API' do
  describe 'with a valid token' do
    it 'should return a successful response' do
      client = Square::Client.new(
        access_token: ENV.fetch('SQUARE_ACCESS_TOKEN_PRODUCTION'),
        environment: 'production',
        timeout: 1
      )
      result = client.locations.list_locations

      expect(result).not_to be_nil
      expect(result.errors).to be_nil
      expect(result.body.locations).not_to be_nil
    end
  end
end
