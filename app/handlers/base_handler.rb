# frozen_string_literal: true

# app/handlers/base_handler.rb
class BaseHandler
  def self.handle(event_data)
    new(event_data).handle
  end

  def initialize(event_data)
    @event_data = event_data
  end

  def handle
    raise NotImplementedError, 'Subclasses must implement the handle method'
  end
end
