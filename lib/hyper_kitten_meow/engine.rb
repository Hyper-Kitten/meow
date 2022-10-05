module HyperKittenMeow
  class Engine < ::Rails::Engine
    isolate_namespace HyperKittenMeow

    initializer "hyper-kitten-meow.importmap", before: "importmap" do |app|
      # NOTE: this will add pins from this engine to the main app
      # https://github.com/rails/importmap-rails#composing-import-maps
      app.config.importmap.paths << root.join("config/importmap.rb")

      # https://github.com/rails/importmap-rails#sweeping-the-cache-in-development-and-test
      app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
    end

    initializer "hyper-kitten-meow.assets.precompile" do |app|
      app.config.assets.precompile += %w[hyper_kitten_meow/application.js]
    end

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
