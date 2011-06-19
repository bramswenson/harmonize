require 'harmonize/gemspec'

Gem::Specification.new do |s|
  s.name        = Harmonize::Name
  s.version     = Harmonize::Version
  s.summary     = Harmonize::Summary
  s.description = Harmonize::Description
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
end
