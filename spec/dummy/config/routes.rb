Rails.application.routes.draw do
  mount HyperKittenMeow::Engine => "/hyper-kitten-meow"
  resources :pages, only: [:show]
  resources :posts, only: [:index, :show]
  namespace :admin do
    get "reports" => "reports#index"
  end
end
