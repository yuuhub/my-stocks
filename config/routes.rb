Rails.application.routes.draw do
  resources :users
  devise_for :users, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" },
  :controllers => { registrations: 'users/registrations' }

  authenticated do
    root :to => 'dashboard#index', as: :authenticated
  end

  get '/pending' => 'users#pending', as: :pending_users
  get '/rejected' => 'users#rejected', as: :rejected_users
  patch 'users/:id/change_status' => 'users#change_status', as: :change_status_user


  get "stocks", to: 'stocks#index'
  post 'dashboard/add_balance'
  get 'transactions', to: 'transactions#index'
  get 'search_stock', to: 'stocks#search'
  get 'show_stock', to: 'stocks#show'
  get 'buy', to: 'stocks#buy'
  get 'sell', to: 'stocks#sell'

  root 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
