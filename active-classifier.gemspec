$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active-classifier/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active-classifier"
  s.version     = ActiveClassifier::VERSION
  s.authors     = ["Evgeny Grep"]
  s.email       = ["gyorms@gmail.com"]
  s.homepage    = ""
  s.summary     = "Easy way to keep class tree and class arguments in the database"
  s.description = "Easy way to keep class tree and class arguments in the database"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "activerecord", "~> 3.2.12"
  s.add_dependency "rails", "~> 3.2.12"

  s.add_development_dependency "sqlite3"
end
