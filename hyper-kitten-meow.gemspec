require_relative "lib/hyper_kitten_meow/version"

Gem::Specification.new do |spec|
  spec.name        = "hyper-kitten-meow"
  spec.version     = HyperKittenMeow::VERSION
  spec.authors     = ["Josh Klina"]
  spec.email       = ["joshua.klina@gmail.com"]
  spec.homepage    = "https://hyperkitten.org"
  spec.summary     = "A simple Rails blogging engine, built for engineers."
  spec.description = "A simple Rails blogging engine that has just the necessites in place for starting a blog."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://hyperkitten.org"
  spec.metadata["changelog_uri"] = "https://hyperkitten.org"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "rails", ">= 7.0.1"
  spec.add_dependency "pg"
  spec.add_dependency "haml"
  spec.add_dependency 'categorical'
  spec.add_dependency 'tzinfo-data'
  spec.add_dependency 'bcrypt'
  spec.add_dependency 'pagy'
  spec.add_dependency 'simple_form'
  spec.add_dependency 'acts_as_list'
  spec.add_dependency 'stimulus-rails'
  spec.add_dependency 'importmap-rails'
  spec.add_dependency 'propshaft'
  spec.add_dependency 'human_urls', '~> 0.1.7-alpha.0'

  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'capybara-screenshot'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency 'puma'
end
