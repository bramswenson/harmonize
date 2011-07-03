module Harmonize
  module Strategies

    class BasicCrudStrategy < Strategy
      def harmonize!
        create_and_update_targets
        destroy_targets_not_found_in_source
      end

      private
        def create_and_update_targets
          sources.each { |source| modify_target(source) }
        end

        def modify_target(source)
          Modifier.modify(source, self)
        end

        def destroy_targets_not_found_in_source
          destroy_scope.find_each { |target| destroy_target(target) }
        end

        def destroy_target(target)
          Modifier.destroy(target, self)
        end

        # if we didn't get any touched_keys, destroy everything in targets scope
        def destroy_scope
          source_keys.empty? ? targets : targets.where("#{harmonizer.key} NOT IN (?)", source_keys)
        end

        def source_keys
          @source_keys ||= sources.map { |s| s[harmonizer.key] }
        end

        class Modifier
          def self.modify(source, strategy)
            new(source, nil, strategy).modify
          end

          def self.destroy(target, strategy)
            new(nil, target, strategy).destroy
          end

          def initialize(source, target, strategy)
            @source     = source
            @target     = target
            @error      = nil # any error that occured during modification
            @type       = nil # [ create, update, destroy ]
            @targets    = strategy.targets
            @log        = strategy.harmonize_log
            @key        = strategy.harmonizer.key
          end

          def modify
            log do
              find_or_initialize_target
              update_target_attributes
              save_target
            end
          end

          def destroy
            log do
              @type = 'destroy'
              @target.destroy
              @modified = true
            end
          end

          def find_or_initialize_target
            target_relation = @targets.where( @key => @source[@key] )
            @target = target_relation.first || target_relation.build
            @type   = @target.new_record? ? 'create' : 'update'
          end

          def update_target_attributes
            @target.attributes = @source
            @modified = @target.changed?
          end

          def save_target
            unless @target.save
              @error = @target.errors.full_messages
            end
          end

          def log
            @before = DateTime.now
            yield
            @after  = DateTime.now
          rescue ActiveRecord::UnknownAttributeError, ActiveRecord::ActiveRecordError => e
            @error = e.message
          ensure
            if @error
              @type  = 'error'
              @after = nil
            end
            create_log_entry if @modified || @error
          end

          def create_log_entry
            @log.modifications.create(
              :instance_id       => @target.id,
              :modification_type => @type,
              :instance_errors   => @error,
              :before_time       => @before,
              :after_time        => @after
            )
          end
        end

    end
  end
end
