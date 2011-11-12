require 'hashie/dash'
require 'harmonize/errors'
module Harmonize
  require 'harmonize/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'harmonize/models'
  autoload :Base,          'harmonize/base'
  autoload :Strategies,    'harmonize/strategies'
  autoload :Configuration, 'harmonize/configuration'
end
ActiveRecord::Base.send :include, Harmonize::Base if defined?(ActiveRecord::Base)
