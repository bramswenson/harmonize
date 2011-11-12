source "http://rubygems.org"
gemspec :path => '../../..'

group :development, :test, :console do
  gem 'activerecord', '3.0.10', :require => 'active_record'
  gem 'sqlite3'
  gem 'rspec-rails', '~> 2'
  gem 'capybara', '~> 1'
  gem 'database_cleaner'
  gem 'factory_girl'
end

platform :mri_18 do
  group :development do
    gem 'ruby-debug'
  end
end

platform :mri_19 do
  group :development do
    gem 'ruby-debug19', :require => 'ruby-debug' unless RUBY_VERSION == '1.9.3'
  end
end
