module Harmonize
  puts "MODELS LOADING"
  module Models
    begin
      require 'active_record'
      Harmonize::Models::Orm = ::ActiveRecord
    rescue LoadError
    end
    module ActiveRecord
      autoload :Log,          'harmonize/models/active_record/log'
      autoload :Modification, 'harmonize/models/active_record/modification'
    end
    module Mongoid
    end
  end
  if Harmonize::Models::Orm.to_s == 'ActiveRecord'
    puts "LOADING ACTIVE RECORD MODELS"
    Modification = Harmonize::Models::ActiveRecord::Modification unless defined?(Modification)
    Log = Harmonize::Models::ActiveRecord::Log unless defined?(Log)
  end
  puts "MODELS LOADED"
end
