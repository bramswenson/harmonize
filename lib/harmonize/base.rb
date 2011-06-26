module Harmonize

  module Base

    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods

      # Enable harmonization on a set of records
      def harmonize(options = {})
        configuration = Harmonize::Configuration.new(options)
        yield(configuration) if block_given?
        configure_harmonizer(configuration)
      end

      def harmonizers
        @harmonizers ||= {}
      end

      def harmonize!(harmonizer_name)
        raise UnknownHarmonizerName.new(harmonizer_name) unless harmonizers.has_key?(harmonizer_name)
        harmonizer = harmonizers[harmonizer_name]
        harmonize_log = create_harmonize_log(harmonizer_name)
        strategy = harmonizer.strategy.new(*harmonizer.strategy_arguments)
        strategy.harmonize(:harmonizer => harmonizer, :harmonize_log => harmonize_log)
        close_harmonize_log(harmonize_log)
      end

      def remove_harmonizer!(harmonizer_name = :default)
        harmonizers.delete(harmonizer_name)
      end

      private

        def close_harmonize_log(harmonize_log)
          harmonize_log.end = DateTime.now
          harmonize_log.save!
          harmonize_log
        end

        def create_harmonize_log(harmonizer_name)
          harmonizer = harmonizers[harmonizer_name]
          Harmonize::Log.create!(
            :start => DateTime.now,
            :class_name => self.class.name,
            :harmonizer_name => harmonizer_name,
            :key => harmonizer.key,
            :strategy => harmonizer.strategy.inspect,
            :strategy_arguments => harmonizer.strategy_arguments.inspect,
          )
        end

        def default_harmonizer_options(harmonizer_name)
          Harmonize::Configuration.new({
            :source => lambda{ harmonizer_source_method(harmonizer_name) },
            :target => lambda{ scoped }
          })
        end

        def harmonizer_source_method(harmonizer_name)
          method_name = "harmonizer_source_#{harmonizer_name}".to_sym
          raise HarmonizerSourceUndefined.new(harmonizer_name) unless respond_to?(method_name)
          send(method_name)
        end

        def validate_harmonizer_configuration(configuration)
          configuration.reverse_merge(default_harmonizer_options(configuration.harmonizer_name))
        end

        def setup_harmonizer_method(harmonizer_name)
          self.class.instance_eval do
            define_method "harmonize_#{harmonizer_name}!" do
              send(:harmonize!, harmonizer_name)
            end
          end
        end

        def configure_harmonizer(configuration)
          configuration = validate_harmonizer_configuration(configuration)
          raise DuplicateHarmonizerName.new(configuration.harmonizer_name.to_s) if harmonizers.has_key?(configuration.harmonizer_name)
          harmonizers[configuration.harmonizer_name] = configuration
          setup_harmonizer_method(configuration.harmonizer_name)
        end

    end

    module InstanceMethods
    end

  end
end

