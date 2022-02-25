require "human_urls"
require "categorical"
require "pagy"
require 'pagy/extras/bootstrap'
require "haml"
require "hyper_kitten/meow/version"
require "hyper_kitten/meow/engine"
require "hyper_kitten/meow/concerns/models/user"
require "hyper_kitten/meow/concerns/models/post"
require "hyper_kitten/meow/concerns/controllers/posts_controller"
require "hyper_kitten/meow/concerns/controllers/tags_controller"
require "hyper_kitten/meow/concerns/controllers/admin/posts_controller"
require "hyper_kitten/meow/concerns/controllers/admin/tags_controller"
require "hyper_kitten/meow/concerns/controllers/admin/admin_controller"

module HyperKitten
  module Meow
    Pagy::DEFAULT[:items] = 10
    # Your code goes here...
  end
end
