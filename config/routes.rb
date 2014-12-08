Tested::Application.routes.draw do
  devise_for :users

  root :to => "sessions#new"
  match '/new', to: "users#new"
  match '/signin',  to: "sessions#new"
  match '/signout',  to: "sessions#destroy", via: :delete
  get 'tags/:tag', to: 'photos#index', as: :tag
  resources :sessions, :only => [:new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :users, :except => [:destroy] do
    resources :comments, :except => [:index]
    member do
        get :following, :followers
    end
    resources :photos do
      member { post :vote }
    end
  end
end
