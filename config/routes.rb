Rails.application.routes.draw do
  root 'home#index'

  resources :tweets, only: [:index] do
    resources :participation, only: [:create]
  end
  resources :sessions, only: [:destroy]
  resources :users, only: [:edit, :update]

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'

  if Rails.env.production?
    match '*path', via: :all, to: 'home#error_404'
  end
end
