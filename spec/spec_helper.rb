# Configure Rails Envinronment
current_env = ENV["RAILS_ENV"] || "test"
ENV["RAILS_ENV"] = "test" unless current_env.match /^test/
puts "ENV: #{current_env}"

require 'harmonize'
require 'rspec'

if defined?(Rails)
  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
  require "rails/test_help"
  require "rspec/rails"
  ActionMailer::Base.delivery_method = :test
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.default_url_options[:host] = "test.com"

  Rails.backtrace_cleaner.remove_silencers!

  # Configure capybara for integration testing
  require "capybara/rails"

  Capybara.default_driver   = :rack_test
  Capybara.default_selector = :css
end

if defined?(::ActiveRecord)
  require 'sqlite3'
  dummy_path = File.expand_path('../dummy', __FILE__)
  puts "DUMMY PATH: #{dummy_path}"
  dummy_db = File.join(dummy_path, 'db', 'test.sqlite3')
  db_config = YAML.load(File.read(File.join(dummy_path, 'config', 'database.yml')))['test'].merge({
    'database' => dummy_db
  })
  migrations_paths = File.join(dummy_path, 'db', 'migrate/')
  File.unlink(db_config['database']) if File.exists?(db_config['database'])
  SQLite3::Database.new(db_config['database'])
  ActiveRecord::Base.establish_connection(db_config)
  ActiveRecord::Migrator.up(migrations_paths)

  class Widget < ::ActiveRecord::Base
  end unless defined?(Widget)
end

require 'database_cleaner'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers

  config.mock_with :rspec

  config.before(:suite) do
    DatabaseCleaner.strategy = defined?(::ActiveRecord::Base) ? :transaction : :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
