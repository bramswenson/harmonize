# encoding: UTF-8
require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load    'rails/tasks/engine.rake'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new(:spec)

#namespace :test do
#  desc 'Setup the test database'
#  task :dbsetup do
#    results = %x(
#      cd spec/dummy &&
#      rm db/*.sqlite3
#      RAILS_ENV=test rake db:migrate
#    )
#    puts "dbsetup: #{results}" unless results == ''
#  end
#
#  desc 'Setup the test database and run rspec'
#  task :run => %w( test:dbsetup test:spec )
#end

task :default => [ 'app:db:create', 'app:db:migrate', 'spec' ]

