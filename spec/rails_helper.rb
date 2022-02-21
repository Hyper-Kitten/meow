# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../spec/dummy/config/environment"
require "rspec/rails"
require "capybara/rails"
require 'factory_bot_rails'

ActiveRecord::Migration.maintain_test_schema!

# Adding support files
Dir[HyperKitten::Meow::Engine.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.order = "random"
end
