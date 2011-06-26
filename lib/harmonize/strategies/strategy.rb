module Harmonize
  module Strategies

    class Strategy
      attr_accessor :harmonizer, :harmonize_log, :sources, :targets

      def initialize(attributes = {})
        update_attributes(attributes)
      end

      def harmonize(attributes)
        update_attributes(attributes)
        self.sources = harmonizer.source.call
        self.targets = harmonizer.target.call
        harmonize!
      end

      def harmonize!
      end

      private

        def update_attributes(attributes)
          attributes.each_pair do |k, v|
            self.send("#{k}=", v)
          end
        end

    end
  end
end
