require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:sangvo)
  end

  test "unsuccessful edit" do
    log_in_as @user
    get edit_user_path @user
    assert_template "users/edit"
    patch user_path(@user), params: {user: {
      name: "",
      email: "invalid@email",
      password: "foo",
      password_confirmation: "baz"
    }}
    assert_template "users/edit"
    assert_select "div.alert", count: 1
  end

  test "success edit" do
    log_in_as @user
    get edit_user_path @user
    assert_template "users/edit"
    name = "Updated name"
    email = "updated_email@gmail.com"
    patch user_path(@user), params: {user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
    }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly fowarding" do
    get edit_user_path @user
    log_in_as @user
    assert_redirected_to edit_user_url(@user)
    name = "Pen test"
    email = "foo@bae.com"
    patch user_path @user, params: {user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
    }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
