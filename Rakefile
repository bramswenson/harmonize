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

task :default => [ 'app:db:create', 'app:db:migrate', 'spec' ]

