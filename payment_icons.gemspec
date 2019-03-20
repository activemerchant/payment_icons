$:.push File.expand_path('../lib', __FILE__)

require 'payment_icons/version'

Gem::Specification.new do |s|
  s.name        = 'payment_icons'
  s.version     = PaymentIcons::VERSION
  s.authors     = ['Nakul Pathak', 'Shopify']
  s.email       = ['payments-integrations@shopify.com']
  s.homepage    = 'https://github.com/activemerchant/payment_icons'
  s.summary     = 'Payment Icon engine that can be integrated with any rails app to give easy access to payment icons for common credit cards, cryptocurrencies, bank transfers and wallets.'
  s.description = 'Mountable rails engine which loads assets (svg files of payment icons) and provides a frozen_record model called PaymentIcon to access these through groups, names of icons, etc.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'frozen_record'
  s.add_dependency 'railties', '>= 5.0', '< 6.0'
  s.add_dependency 'sass'

  s.add_development_dependency('rails', '>= 5.0', '< 6.0')
end
