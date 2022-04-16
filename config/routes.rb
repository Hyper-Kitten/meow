HyperKittenMeow::Engine.routes.draw do
  namespace :admin do
    resources :posts
    resources :tags
    resources :users
    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    get    'logout'  => 'sessions#destroy'
  end
end
