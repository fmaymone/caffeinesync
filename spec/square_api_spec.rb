require 'rails_helper'
require 'square'

RSpec.describe 'Testing Square API' do

  describe 'validations' do
    describe 'it validates name' do
      client = Square::Client.new(
        access_token: ENV.fetch('SQUARE_ACCESS_TOKEN_SANDBOX'),
        environment: 'production',
        timeout: 1
      )
      result = client.locations.list_locations
      debugger
      puts 'Hello'
    end
  end

end