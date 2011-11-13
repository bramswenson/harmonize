module Harmonize
  module Models
    module Mongoid
      class Modification
        include ::Mongoid::Document
        include ::Mongoid::Timestamps

        field :instance_id, :type => String
        field :modification_type, :type => String
        field :before_time, :type => DateTime
        field :after_time, :type => DateTime
        field :instance_errors, :type => String

        validates :modification_type, :presence => true, :inclusion => %w( create update destroy error )

        #serialize :instance_errors

        belongs_to :log, :class_name => "Harmonize::Models::Mongoid::Log", :inverse_of => :modifications

        scope :created,   lambda { where(:modification_type => 'create') }
        scope :updated,   lambda { where(:modification_type => 'update') }
        scope :destroyed, lambda { where(:modification_type => 'destroy') }
        scope :errored,   lambda { where(:modification_type => 'error') }
      end
    end
  end
end
