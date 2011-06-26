# encoding: UTF-8
require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

namespace :test do
  RSpec::Core::RakeTask.new(:spec)
  desc 'Setup the test database'
  task :dbsetup do
    results = %x(
      cd spec/dummy &&
      rm db/migrate/*create_harmonize_tables.rb &&
      rm db/*.sqlite3 &&
      rails g harmonize:migration &&
      RAILS_ENV=test rake db:migrate
    )
    puts "dbsetup: #{results}" unless results == ''
  end

  desc 'Setup the test database and run rspec'
  task :run => %w( test:dbsetup test:spec )
end

task :default => 'test:run'

