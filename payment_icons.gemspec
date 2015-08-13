$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "payment_icons/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "payment_icons"
  s.version     = PaymentIcons::VERSION
  s.authors     = ["Nakul Pathak"]
  s.email       = ["nakul.pathak@shopify.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of PaymentIcons."
  s.description = "TODO: Description of PaymentIcons."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "sqlite3"
end
