Rails.application.routes.draw do
  resources :places do
    resource :favorite, only: [:create, :destroy]
    resource :visit, only: [:create, :destroy]
  end
  resources :favorites, only: [:index]
  resources :visits, only: [:index]
  resources :users, only: [:new, :create]
  get "mypage", to: "users#mypage"
  get "mypage/edit", to: "users#edit", as: "edit_mypage"
  patch "mypage", to: "users#update"
  delete "mypage", to: "users#destroy"
  
  resource :session, only: [:new, :create, :destroy]
  root "places#index"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
