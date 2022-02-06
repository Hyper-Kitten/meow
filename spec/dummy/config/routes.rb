Rails.application.routes.draw do
  mount HyperKitten::Meow::Engine => "/hyper-kitten-meow"
end
