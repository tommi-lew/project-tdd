RACK_ENV = "test"
require_relative File.join("..", "web.rb")
require "rack/test"
require "rspec"

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
