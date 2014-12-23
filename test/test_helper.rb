ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# See https://github.com/freerange/mocha#rails
require 'minitest/spec'

# See http://gofreerange.com/mocha/docs/
require 'mocha/mini_test'

# See http://pryrepl.org/
require 'pry'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Tests do not work unless transactional fixtures are not used; do not know why yet.
  self.use_transactional_fixtures = false

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  # Tests do not work unless transactional fixtures are not used; do not know why yet.
  self.use_transactional_fixtures = false
end
