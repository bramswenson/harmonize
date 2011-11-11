module Harmonize
  module Strategies

    class BasicCrudStrategy < Strategy

      def harmonize!
        touched_keys = create_and_update_targets
        destroy_targets_not_found_in_source(touched_keys)
      end

      private

        def create_and_update_targets
          sources.each.inject([]) do |keys, source|
            target_instance = find_target_instance(harmonizer.key, source[harmonizer.key])
            modification = initialize_modification(target_instance)
            modification = harmonize_target_instance!(target_instance, source, modification)
            modification.save! if modification && modification.instance_id
            keys << source[harmonizer.key]
          end
        end

        def destroy_targets_not_found_in_source(touched_keys)
          # if we didn't get any touched_keys, destroy everything in targets scope
          destroy_scope = touched_keys.empty? ? targets : targets.where("#{harmonizer.key} NOT IN (?)", touched_keys)
          destroy_scope.find_each do |instance|
            modification = harmonize_log.modifications.build(
              :modification_type => 'destroy', :before_time => DateTime.now,
              :instance_id => instance.id
            )
            instance.destroy
            modification.update_attributes!(:after_time => DateTime.now)
          end
        end

        def find_target_instance(key, value)
          target_relation = targets.where(key => value)
          instance = target_relation.first rescue nil
          instance ||= target_relation.build
          instance
        end

        def initialize_modification(instance)
          unless instance.new_record?
            harmonize_log.modifications.build(:modification_type => 'update', :before_time => DateTime.now)
          else
            harmonize_log.modifications.build(:modification_type => 'create', :before_time => DateTime.now)
          end
        end

        def harmonize_target_instance!(target_instance, source, modification)
          target_instance, error_message = update_target_attributes(target_instance, source)
          unless (target_instance.changed? or error_message)
            modification.destroy
            return false
          end
          target_instance, error_message = save_target(target_instance) unless error_message
          if error_message
            modification.attributes = { :modification_type => 'error', :instance_errors => error_message }
          else
            modification.attributes = { :after_time => DateTime.now, :instance_id => target_instance.id }
          end
          modification
        end

        def update_target_attributes(target_instance, source)
          error_message = false
          begin
            target_instance.attributes = source
          rescue ActiveRecord::UnknownAttributeError => e
            error_message = e.message
          end
          return target_instance, error_message
        end

        def save_target(target_instance)
          error_message = false
          begin
            unless target_instance.save
              error_message = target_instance.errors.full_messages
            end
          rescue ActiveRecord::ActiveRecordError => e
            error_message = e.message
          end
          return target_instance, error_message
        end

    end
  end
end
