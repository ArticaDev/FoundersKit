Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # api namespace
  namespace :api do
    namespace :v1 do
      get "hello" => "api#hello"
      get "overview" => "users#overview"
      resources :opportunities do
        member do
          post "add_note"
          delete "delete_note"
          patch "update_note"
        end
      end
      resources :users
      resources :customers
      resources :transactions do
        post "summary", on: :collection
      end
      resources :inventory_items
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
