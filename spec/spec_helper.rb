begin
  require 'rspec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'rspec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__) + '/../lib/hudson_erb')

require 'hudson_erb'
require 'mocha'

RSpec.configure do |config|
  config.mock_with :mocha
end
