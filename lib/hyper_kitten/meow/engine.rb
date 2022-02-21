module HyperKitten
  module Meow
    class Engine < ::Rails::Engine
      isolate_namespace HyperKitten::Meow

      config.generators do |g|
        g.test_framework :rspec
      end
    end
  end
end
