module Harmonize
  autoload :Base, 'harmonize/base'
end
ActiveRecord::Base.send :include, Harmonize::Base
