module Harmonize
  module Models
    module ActiveRecord
      class Log < ::ActiveRecord::Base
        set_table_name :harmonize_logs

        validates :key, :class_name, :harmonizer_name, :strategy, :strategy_arguments, :presence => true

        ModificationOptions = { :class_name => "Harmonize::Models::ActiveRecord::Modification",
                                :foreign_key => :harmonize_log_id }

        has_many :modifications, ModificationOptions.merge(:inverse_of => :log, :dependent => :destroy)
        has_many :created,       ModificationOptions.merge(:conditions => { :modification_type => 'create' })
        has_many :updated,       ModificationOptions.merge(:conditions => { :modification_type => 'update' })
        has_many :destroyed,     ModificationOptions.merge(:conditions => { :modification_type => 'destroy'})
        has_many :errored,       ModificationOptions.merge(:conditions => { :modification_type => 'error'  })

      end
    end
  end
end
