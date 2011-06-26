module Harmonize
  module Strategies

    class BasicCrudStrategy < Strategy

      def find_target_instance(key, value)
        target_relation = targets.where(key => value)
        instance = target_relation.first rescue nil
        instance ||= target_relation.build
        instance
      end

      def create_modification(instance)
        unless instance.new_record?
          harmonize_log.modifications.create!(:modification_type => 'update', :before_time => DateTime.now)
        else
          harmonize_log.modifications.create!(:modification_type => 'create', :before_time => DateTime.now)
        end
      end

      def harmonize_target_instance!(target_instance, source, modification)
        # TODO: this is a mess
        error_message = nil
        errored  = false
        begin
          unless target_instance.update_attributes(source)
            errored = true
            error_message = target_instance.errors.full_messages
          end
        rescue ActiveRecord::ActiveRecordError, ActiveRecord::UnknownAttributeError => e
          errored = true
          error_message = e.message
        end
        unless errored
          modification.update_attributes!(:after_time => DateTime.now, :instance_id => target_instance.id)
        else
          modification.update_attributes!(:modification_type => 'error', :instance_errors => error_message)
        end
      end

      def create_and_update_targets
        sources.each.inject([]) do |keys, source|
          target_instance = find_target_instance(harmonizer.key, source[harmonizer.key])
          modification = create_modification(target_instance)
          harmonize_target_instance!(target_instance, source, modification)
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

      def harmonize!
        touched_keys = create_and_update_targets
        destroy_targets_not_found_in_source(touched_keys)
      end
    end
  end
end
