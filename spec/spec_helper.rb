# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["ENV"] ||= "test"

initializer = File.expand_path("../../initializer.rb", __FILE__)
spec_support_glob = File.expand_path("../support/**/*.rb", __FILE__)

require initializer
require 'rspec'

Dir[spec_support_glob].each do |support_file|
  require support_file
end

RSpec.configure do |config|
  config.expect_with :rspec do |assertion|
    assertion.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
