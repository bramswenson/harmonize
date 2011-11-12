module Harmonize
  module Models
    module ActiveRecord
      class Modification < ::ActiveRecord::Base
        set_table_name :harmonize_modifications

        validates :harmonize_log_id, :modification_type, :presence => true
        validates :modification_type, :inclusion => %w( create update destroy error )

        serialize :instance_errors

        belongs_to :log, :class_name => "Harmonize::Models::ActiveRecord::Log",
                   :foreign_key => :harmonize_log_id, :inverse_of => :modifications

        scope :created,   where(:modification_type => 'create')
        scope :updated,   where(:modification_type => 'update')
        scope :destroyed, where(:modification_type => 'destroy')
        scope :errored,   where(:modification_type => 'error')
      end
    end
  end
end
