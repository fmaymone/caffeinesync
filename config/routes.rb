Rails.application.routes.draw do
  post '/webhooks/square', to: 'square_webhooks#handle_event'
end
