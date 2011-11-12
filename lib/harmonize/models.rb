module Harmonize
  puts "MODELS LOADING"
  module Models
    module ActiveRecord
      autoload :Log,          'harmonize/models/active_record/log'
      autoload :Modification, 'harmonize/models/active_record/modification'
    end
    module Mongoid
    end
  end
  Modification = Harmonize::Models::ActiveRecord::Modification unless defined?(Modification)
  Log = Harmonize::Models::ActiveRecord::Log unless defined?(Log)
  puts "MODELS LOADED"
end
