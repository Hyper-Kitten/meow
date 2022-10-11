HyperKittenMeow::Engine.routes.draw do
  namespace :admin do
    resources :posts
    resources :pages
    resources :tags
    resources :users
    resources :menus
    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    get    'logout'  => 'sessions#destroy'
  end
  resources :pages, only: [:show]
end
