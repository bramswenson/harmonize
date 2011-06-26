# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110626061654) do

  create_table "harmonize_logs", :force => true do |t|
    t.string   "key"
    t.string   "class_name"
    t.string   "harmonizer_name"
    t.string   "strategy"
    t.string   "strategy_arguments"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "harmonize_logs", ["class_name", "harmonizer_name"], :name => "index_harmonize_logs_on_class_name_and_harmonizer_name"

  create_table "harmonize_modifications", :force => true do |t|
    t.integer  "harmonize_log_id"
    t.integer  "instance_id"
    t.string   "modification_type"
    t.datetime "before_time"
    t.datetime "after_time"
    t.text     "instance_errors"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "harmonize_modifications", ["harmonize_log_id", "instance_id", "modification_type"], :name => "index_harmonize_modification_with_id_and_type"
  add_index "harmonize_modifications", ["harmonize_log_id", "instance_id"], :name => "index_harmonize_modification_with_id"
  add_index "harmonize_modifications", ["harmonize_log_id"], :name => "index_harmonize_modifications_on_harmonize_log_id"

  create_table "widgets", :force => true do |t|
    t.string   "name"
    t.integer  "cost_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
