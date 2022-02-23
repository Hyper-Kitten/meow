module HyperKitten
  module Meow
    class Engine < ::Rails::Engine
      isolate_namespace HyperKitten::Meow

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_bot
        g.factory_bot dir: 'spec/factories'
        g.assets false
        g.helper false
      end
    end
  end
end
