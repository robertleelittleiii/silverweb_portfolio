# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'silverweb_portfolio/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'silverweb_portfolio'
  s.version     = SilverwebPortfolio::VERSION
  s.authors     = ['Robert Lee Little III']
  s.email       = ['rob@silverwebsystems.com']
  s.homepage    = 'http://www.silverwebsystems.com'
  s.summary     = 'This is gem to create a basic portfolio on to of silverweb_cms'
  s.description = 'This gem is an add on to the silverweb_cms.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_runtime_dependency "rails", '~> 5.1'
  s.add_dependency 'silverweb_cms', '0.1.0'

  s.add_development_dependency 'mysql'
end
