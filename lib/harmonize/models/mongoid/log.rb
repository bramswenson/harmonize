module Harmonize
  module Models
    module Mongoid
      class Log
        include ::Mongoid::Document
        include ::Mongoid::Timestamps
        store_in :harmonize_logs

        field :key, :type => String
        field :class_name, :type => String
        field :harmonizer_name, :type => String
        field :strategy, :type => String
        field :strategy_arguments, :type => String
        field :start, :type => DateTime
        field :end, :type => DateTime

        validates :key, :class_name, :harmonizer_name, :strategy, :strategy_arguments, :presence => true

        ModificationOptions = { :class_name => "Harmonize::Models::Mongoid::Modification" }

        has_many :modifications, ModificationOptions.merge(:inverse_of => :log, :dependent => :destroy)
        def created; modifications.created; end
        def updated; modifications.updated; end
        def destroyed; modifications.destroyed; end
        def errored; modifications.errored; end
      end
    end
  end
end
