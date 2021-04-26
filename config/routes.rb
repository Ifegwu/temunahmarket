# Rails.application.routes.draw do

#   get 'message/create'
#   root 'pages#home'
  
#   get '/dashboard', to: 'users#dashboard'
#   get '/users/:id', to: 'users#show', as: 'users'
#   get '/selling_orders', to: 'orders#selling_orders'
#   get '/buying_orders', to: 'orders#buying_orders'
#   get '/orders/:id', to: 'orders#show', as: "order_detail"
#   get '/all_requests', to: 'requests#list'
#   get '/request_offers/:id', to: 'requests#offers', as: 'request_offers'
#   get '/my_offers', to: 'requests#my_offers'
#   get '/search', to: 'pages#search'
#   get '/calendar', to: 'pages#calendar'
#   get '/plans', to: 'pages#plans'
#   get '/settings/payment', to: 'users#payment', as: 'settings_payment'
#   get '/settings/payout', to: 'users#payout', as: 'settings_payout'
#   get '/gigs/:id/checkout/:pricing_type', to: 'gigs#checkout', to: 'gigs#checkout', as: 'checkout'
#   get '/earnings', to: 'users#earnings', as: 'earnings'
#   get '/conversations', to: 'conversations#list', as: "conversations"
#   get '/conversations/:id', to: 'conversations#show', as: "conversation_detail"

#   post '/user/edit', to: 'users#update'
#   post '/offers', to: 'offers#create'
#   post '/reviews', to: 'reviews#create'
#   post '/settings/payment', to: 'users#update_payment', as: "update_payment"
#   post '/settings/payout', to: 'users#update_payout', as: "update_payout"
#   post '/users/withdraw', to: 'users#withdraw', as: 'withdraw'
#   post '/messages', to: 'messages#create'
#   post '/comments', to: 'comments#create'
#   post '/subscribe', to: 'subscriptions#subscribe'
#   post '/webhook', to: 'subscriptions#webhook'

#   put '/orders/:id/complete', to: 'orders#complete', as: 'complete_order'
#   put '/offers/:id/accept', to: 'offers#accept', as: 'accept_offer'
#   put '/offers/:id/reject', to: 'offers#reject', as: 'reject_offer'

#   delete '/users/remove_subscription', to: 'users#remove_subscription', as: 'remove_subscription'

#   mount ActionCable.server => '/cable'

#   resources :gigs do
#     member do
#       delete :delete_photo
#       post :upload_photo
#     end
#     resources :orders, only: [:create]
#   end

#   resources :requests
#   devise_for :users,
#               path: '',
#               path_names: {sign_up: 'register', sign_in: 'login', edit: 'profile', sign_out: 'logout'},
#               controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}
  
# end

Rails.application.routes.draw do
  scope '(:locale)', :locale => /en|de/  do
    devise_for :users,
              path: '',
              path_names: {sign_up: 'register', sign_in: 'login', edit: 'profile', sign_out: 'logout'}, skip: :omniauth_callbacks
    get 'message/create'
    root 'pages#home'
    
    get '/dashboard', to: 'users#dashboard'
    
    
    get '/all_requests', to: 'requests#list'
    get '/request_offers/:id', to: 'requests#offers', as: 'request_offers'
    get '/my_offers', to: 'requests#my_offers'
    get '/search', to: 'pages#search'
    get '/calendar', to: 'pages#calendar'
    get '/plans', to: 'pages#plans'
    get '/settings/payment', to: 'users#payment', as: 'settings_payment'
    get '/settings/payout', to: 'users#payout', as: 'settings_payout'
    get '/gigs/:id/checkout/:pricing_type', to: 'gigs#checkout', as: 'checkout'
    get '/earnings', to: 'users#earnings', as: 'earnings'
    

    post '/user/edit', to: 'users#update'
    post '/offers', to: 'offers#create'
    post '/reviews', to: 'reviews#create'
    post '/settings/payment', to: 'users#update_payment', as: "update_payment"
    post '/settings/payout', to: 'users#update_payout', as: "update_payout"
    post '/users/withdraw', to: 'users#withdraw', as: 'withdraw'
    post '/messages', to: 'messages#create'
    post '/comments', to: 'comments#create'
    post '/subscribe', to: 'subscriptions#subscribe'
    post '/webhook', to: 'subscriptions#webhook'

   
    put '/offers/:id/accept', to: 'offers#accept', as: 'accept_offer'
    put '/offers/:id/reject', to: 'offers#reject', as: 'reject_offer'

    delete '/users/remove_subscription', to: 'users#remove_subscription', as: 'remove_subscription'

    mount ActionCable.server => '/cable'

    
    
  end
  
  get '/users/:id', to: 'users#show', as: 'users'
  get '/selling_orders', to: 'orders#selling_orders'
  get '/buying_orders', to: 'orders#buying_orders'
  get '/orders/:id', to: 'orders#show', as: "order_detail"

  get '/conversations', to: 'conversations#list', as: "conversations"
  get '/conversations/:id', to: 'conversations#show', as: "conversation_detail"

  put '/orders/:id/complete', to: 'orders#complete', as: 'complete_order'

  resources :requests

  resources :gigs do
    member do
      delete :delete_photo
      post :upload_photo
    end
    resources :orders, only: [:create]
  end
  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }
  # devise_for :users,
  #             path: '',
  #             path_names: {sign_up: 'register', sign_in: 'login', edit: 'profile', sign_out: 'logout'},
  #             controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}

end
