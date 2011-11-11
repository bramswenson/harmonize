source "http://rubygems.org"
gemspec :path => '../../..'


group :development, :test, :console do
  gem 'rails', '~> 3.1'
  gem 'sqlite3'
  gem 'rspec-rails', '~> 2'
  if RUBY_VERSION == '1.9.2'
    gem 'ruby-debug19', :require => 'ruby-debug'
  else
    gem 'ruby-debug'
  end
  gem 'capybara', '~> 1'
  gem 'database_cleaner'
  gem 'factory_girl'
end
