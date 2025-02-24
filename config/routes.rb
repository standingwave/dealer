Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :cards do
    member do
      get "edit_attribute/:attribute", action: :edit_attribute, as: :edit_attribute
      patch "update_attribute/:attribute", action: :update_attribute, as: :update_attribute
    end
    collection do
      get ":gatherer_id/details", action: :details, as: :details
    end
  end
  
  resources :card_sets
  resources :users
  resources :decks

  # Proxy requests to other servers
  get "proxy" => "proxy#index", as: :proxy
  
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "cards#index"
end
