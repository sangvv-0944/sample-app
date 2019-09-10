require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: {user: {
        name: "user",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
      }}
    end
    assert_template "users/new"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: {user: {
        name: "user",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
      }}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try login before activation
    log_in_as user
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    # valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: {user: {
        name: "Test User",
        email: "test_user@gmail.com",
        password: "password",
        password_confirmation: "password"
      }}
    end
    follow_redirect!
    assert_template "users/show"
    assert_not flash.nil?
  end

  test "valid signup infomation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: {user: {
        name: "Test Signup",
        email: "test_signup@gmail.com",
        password: "123456",
        password_confirmation: "123456"
      }}
    end
    follow_redirect!
    # assert_template "users/show"
    # assert is_logged_in?
  end
end
