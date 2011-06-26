module Harmonize
  class Modification < ActiveRecord::Base
    set_table_name :harmonize_modifications

    belongs_to :log, :class_name => "Harmonize::Log",
               :foreign_key => :harmonize_log_id, :inverse_of => :modifications

    validates :harmonize_log_id, :modification_type, :presence => true
    validates :modification_type, :inclusion => %w( create update destroy error )
    serialize :instance_errors
  end
end
