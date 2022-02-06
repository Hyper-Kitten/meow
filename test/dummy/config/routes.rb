Rails.application.routes.draw do
  mount Hyper::Kitten::Meow::Engine => "/hyper-kitten-meow"
end
