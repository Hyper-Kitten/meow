require "human_urls"
require "categorical"
require "pagy"
require 'pagy/extras/bootstrap'
require "haml"
require "simple_form"
require "hyper_kitten_meow/version"
require "hyper_kitten_meow/engine"
require "hyper_kitten_meow/concerns/models/user"
require "hyper_kitten_meow/concerns/models/post"
require "hyper_kitten_meow/concerns/models/page"
require "hyper_kitten_meow/concerns/controllers/admin/posts_controller"
require "hyper_kitten_meow/concerns/controllers/admin/tags_controller"
require "hyper_kitten_meow/concerns/controllers/admin/users_controller"
require "hyper_kitten_meow/concerns/controllers/admin/admin_controller"

module HyperKittenMeow
  Pagy::DEFAULT[:items] = 10
  # Your code goes here...
end
