Rails.application.routes.draw do
  root 'home#index'

  resources :tweets, only: [:index] do
    resources :participation, only: [:create]
  end
  
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
end
