module Hyper
  module Kitten
    module Meow
      class Engine < ::Rails::Engine
        isolate_namespace Hyper::Kitten::Meow
      end
    end
  end
end
