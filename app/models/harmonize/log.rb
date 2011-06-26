module Harmonize
  class Log < ActiveRecord::Base
    set_table_name :harmonize_logs

    has_many :modifications, :class_name => "Harmonize::Modification",
             :foreign_key => :harmonize_log_id, :inverse_of => :log,
             :dependent => :destroy

    validates :key, :class_name, :harmonizer_name, :strategy, :strategy_arguments, :presence => true
  end
end
