# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../spec/dummy/config/environment"

require "rspec/rails"
require "selenium/webdriver"
require "capybara/rails"
require "capybara-screenshot/rspec"
require "action_text/system_test_helper"
require "factory_bot_rails"

ActiveRecord::Migration.maintain_test_schema!

# Adding support files
Dir[HyperKittenMeow::Engine.root.join("spec/support/**/*.rb")].each { |f| require f }

# Chrome headless driver
Capybara.register_driver :headless_chrome do |app|
  opts = Selenium::WebDriver::Chrome::Options.new

  chrome_args = %w[--disable-dev-shm-usage --headless --no-sandbox --disable-gpu --window-size=1920,1080]
  chrome_args.each { |arg| opts.add_argument(arg) }
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts)
end

Capybara.javascript_driver = :headless_chrome
Capybara::Screenshot.register_driver(:selenium_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActionText::SystemTestHelper, type: :feature

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.order = "random"
end
