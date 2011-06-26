module Harmonize
  module Strategies

    class BasicCrudStrategy < Strategy

      def find_target_instance(key, value)
        target_relation = targets.where(key => value)
        instance = target_relation.first rescue nil
        instance ||= target_relation.build
        instance
      end

      def do_not_delete_these_keys
        @do_not_delete_these_keys ||= []
      end

      def create_modification(instance)
        unless instance.new_record?
          harmonize_log.modifications.create!(:modification_type => 'update', :before_time => DateTime.now)
        else
          harmonize_log.modifications.create!(:modification_type => 'create', :before_time => DateTime.now)
        end
      end

      def harmonize_target_instance!(target_instance, source, modification)
        unless target_instance.update_attributes(source)
          modification.update_attributes!(:modification_type => 'error',
                                          :instance_errors => target_instance.errors.full_messages)
        else
          modification.update_attributes!(:after_time => DateTime.now, :instance_id => target_instance.id)
        end
      end

      def create_and_update_targets
        sources.each do |source|
          target_instance = find_target_instance(harmonizer.key, source[harmonizer.key])
          modification = create_modification(target_instance)
          harmonize_target_instance!(target_instance, source, modification)
          do_not_delete_these_keys << source[harmonizer.key]
        end
      end

      def destroy_targets_not_found_in_source
        targets.where(harmonizer.key => !do_not_delete_these_keys).find_each do |instance|
          modification = harmonize_log.modifications.build(
            :modification_type => 'destroy', :before_time => DateTime.now,
            :instance_id => instance.id
          )
          instance.destroy
          modification.update_attributes!(:after_time => DateTime.now)
        end
      end

      def harmonize!
        create_and_update_targets
        destroy_targets_not_found_in_source
      end
    end
  end
end
