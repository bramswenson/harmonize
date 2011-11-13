module Harmonize
  puts "MODELS LOADING"
  module Models
    begin
      require 'mongoid'
      Harmonize::Models::Orm = ::Mongoid
    rescue LoadError
    end
    begin
      require 'active_record'
      Harmonize::Models::Orm = ::ActiveRecord
    rescue LoadError
    end unless defined?(Harmonize::Models::Orm)
    module ActiveRecord
      autoload :Log,          'harmonize/models/active_record/log'
      autoload :Modification, 'harmonize/models/active_record/modification'
    end
    module Mongoid
      autoload :Log,          'harmonize/models/mongoid/log'
      autoload :Modification, 'harmonize/models/mongoid/modification'
    end
  end
  case Harmonize::Models::Orm.to_s
  when 'ActiveRecord'
    puts "LOADING ACTIVE RECORD MODELS"
    Modification = Harmonize::Models::ActiveRecord::Modification unless defined?(Modification)
    Log = Harmonize::Models::ActiveRecord::Log unless defined?(Log)
  when 'Mongoid'
    puts "LOADING MONGOID MODELS"
    Modification = Harmonize::Models::Mongoid::Modification unless defined?(Modification)
    Log = Harmonize::Models::Mongoid::Log unless defined?(Log)
  end
  puts "MODELS LOADED"
end
