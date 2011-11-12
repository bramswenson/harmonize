module Harmonize
  class Engine < ::Rails::Engine
    load_path = File.expand_path("../..", __FILE__)
    puts "LOAD PATH: #{load_path}"
    config.autoload_paths << load_path
    model_path = File.expand_path("../../models/active_record", __FILE__)
    puts "MODEL PATH: #{model_path}"
    paths["app/models"] << model_path
  end
end
