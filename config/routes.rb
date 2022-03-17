HyperKittenMeow::Engine.routes.draw do
  namespace :admin do
    resources :posts
    resources :tags
    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    get    'logout'  => 'sessions#destroy'
  end
end
