# frozen_string_literal: true

Rails.application.routes.draw do
  get '/products', to: 'products#index'
  post '/webhooks/square', to: 'square_webhooks#handle_event'
end
