$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "payment_icons/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "payment_icons"
  s.version     = PaymentIcons::VERSION
  s.authors     = ["Nakul Pathak"]
  s.email       = ["nakul.pathak@shopify.com"]
  s.homepage    = "https://github.com/Shopify/payment_icons"
  s.summary     = "Payment Icon engine that can be integrated with any rails app to give easy access to common payment icons like visa, mastercard, etc."
  s.description = "Mountable rails engine with which loads assets (svg files of payment icons) and provides a frozen_record model called PaymentIcon to access these through groups, names of icons, etc."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1"
  s.add_dependency "frozen_record"

  s.add_development_dependency 'sqlite3'
end
