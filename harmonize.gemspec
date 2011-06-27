$LOAD_PATH.unshift(File.expand_path('lib', File.dirname(__FILE__)))
require 'harmonize/gemdata'

Gem::Specification.new do |s|
  s.name        = Harmonize::Gemdata::Name
  s.version     = Harmonize::Gemdata::Version
  s.authors     = Harmonize::Gemdata::Authors
  s.email       = Harmonize::Gemdata::Email
  s.summary     = Harmonize::Gemdata::Summary
  s.description = Harmonize::Gemdata::Description
  s.homepage    = Harmonize::Gemdata::Homepage
  s.files       = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md"]

  s.add_dependency('hashie')
end
