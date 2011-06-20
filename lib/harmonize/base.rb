module Harmonize
  module Base

    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods
      def harmonize(*args)
      end
    end

    module InstanceMethods
    end

  end
end

