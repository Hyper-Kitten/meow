require_relative "lib/hyper_kitten/meow/version"

Gem::Specification.new do |spec|
  spec.name        = "hyper-kitten-meow"
  spec.version     = HyperKitten::Meow::VERSION
  spec.authors     = ["Josh Klina"]
  spec.email       = ["joshua.klina@gmail.com"]
  spec.homepage    = "https://hyperkitten.org"
  spec.summary     = "A simple Rails blogging engine, built for engineers."
  spec.description = "A simple Rails blogging engine that has just the necessites in place for starting a blog."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

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
  spec.add_dependency 'human_urls', '~> 0.1.7-alpha.0'

  # Used for local testing
  # spec.add_runtime_dependency "human_urls"
  # spec.add_runtime_dependency "categorical"

  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'puma'
end
