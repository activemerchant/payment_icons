$:.push File.expand_path('../lib', __FILE__)

require 'payment_icons/version'

Gem::Specification.new do |s|
  s.name        = 'payment_icons'
  s.version     = PaymentIcons::VERSION
  s.authors     = ['Nakul Pathak', 'Shopify']
  s.email       = ['payments-integrations@shopify.com']
  s.homepage    = 'https://github.com/Shopify/payment_icons'
  s.summary     = 'Payment Icon engine that can be integrated with any rails app to give easy access to common payment icons like visa, mastercard, etc.'
  s.description = 'Mountable rails engine which loads assets (svg files of payment icons) and provides a frozen_record model called PaymentIcon to access these through groups, names of icons, etc.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'railties', '>= 4.1', '< 5.1'
  s.add_dependency 'frozen_record'
  s.add_dependency 'rails', '>= 4.1', '< 5.1'
  s.add_dependency 'sass'
end
