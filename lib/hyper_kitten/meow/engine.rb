module HyperKitten
  module Meow
    class Engine < ::Rails::Engine
      isolate_namespace HyperKitten::Meow
    end
  end
end
