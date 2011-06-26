module Harmonize
  class Configuration < Hashie::Dash
    property :source
    property :target
    property :key,                :default => :id
    property :harmonizer_name,    :default => :default
    property :strategy,           :default => Harmonize::Strategies::BasicCrudStrategy
    property :strategy_arguments, :default => Hash.new
  end
end
