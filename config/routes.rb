Rails.application.routes.draw do
  resources :users
  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resource :cart, only: [ :show ] do
    post "add_to_cart/:book_id", to: "carts#add_to_cart", as: "add_to_cart"
    delete "remove_from_cart/:book_id", to: "carts#remove_from_cart", as: "remove_from_cart"
  end

  resources :orders, only: [ :create, :show, :destroy ]

  # Defines the root path route ("/")
  # root "posts#index"
end
