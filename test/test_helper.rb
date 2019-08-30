ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
  fixtures :all

  def is_logged_in?
    session[:user_id].present?
  end
end
