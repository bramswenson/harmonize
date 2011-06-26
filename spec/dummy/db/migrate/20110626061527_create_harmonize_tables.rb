class CreateHarmonizeTables < ActiveRecord::Migration
  def self.up
    create_table :harmonize_logs do |t|
      t.string    :key
      t.string    :class_name
      t.string    :harmonizer_name
      t.string    :strategy
      t.string    :strategy_arguments
      t.datetime  :start
      t.datetime  :end
      t.timestamps
    end
    add_index :harmonize_logs, [ :class_name, :harmonizer_name ]

    create_table :harmonize_modifications do |t|
      t.integer  :harmonize_log_id
      t.integer  :instance_id
      t.string   :modification_type
      t.datetime :before_time
      t.datetime :after_time
      t.text     :instance_errors
      t.timestamps
    end
    add_index :harmonize_modifications, :harmonize_log_id
    add_index :harmonize_modifications, [ :harmonize_log_id, :instance_id ], :name => 'index_harmonize_modification_with_id'
    add_index :harmonize_modifications, [ :harmonize_log_id, :instance_id, :modification_type ], :name => 'index_harmonize_modification_with_id_and_type'
  end

  def self.down
    drop_table :harmonize_logs
    drop_table :harmonize_modifications
  end
end

