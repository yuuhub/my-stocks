Rails.application.routes.draw do
  resources :users
  devise_for :users, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" },
  :controllers => { registrations: 'users/registrations' }

  authenticated do
    root :to => 'dashboard#index', as: :authenticated
  end

  get "stocks", to: 'stocks#index'
  post 'dashboards/add_balance'
  get 'transactions', to: 'transactions#index'

  root 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
