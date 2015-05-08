$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "silverweb_portfolio/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "silverweb_portfolio"
  s.version     = SilverwebPortfolio::VERSION
  s.authors     = ["Robert Lee Little III"]
  s.email       = ["rob@silverwebsystems.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of SilverwebPortfolio."
  s.description = "TODO: Description of SilverwebPortfolio."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency 'silverweb_cms'
  
  s.add_development_dependency "mysql"
end
