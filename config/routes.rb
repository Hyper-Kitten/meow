HyperKittenMeow::Engine.routes.draw do
  namespace :admin do
    root to: "posts#index"
    resources :posts
    resources :pages
    resources :tags
    resources :users
    resources :first_users, only: [:new, :create]
    resources :menus
    get    "login"   => "sessions#new"
    post   "login"   => "sessions#create"
    get    "logout"  => "sessions#destroy"
  end
end
