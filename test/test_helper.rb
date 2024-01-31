ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../test/dummy/config/environment.rb',  __FILE__)
require "rails/test_help"

Minitest.backtrace_filter = Minitest::BacktraceFilter.new

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActiveSupport::TestCase.fixtures(:all)
end
