require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Sang Vo", email: "sangvo@gmail.com",
                     password: "testpass", password_confirmation: "testpass")
  end

  test "should user be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 254 + "@gmail.com"
    assert_not @user.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w(user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com)
    invalid_addresses.each do |invalid_addr|
      @user.email = invalid_addr
      assert_not @user.valid?, "#{invalid_addr.inspect} should not invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  test "email addresses should be saved as lower-case" do
    mixed_email = "FoO@eXamPle.coM"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a mininum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "assocaited microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "lorem ispum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    sangvo = users(:sangvo)
    vitcon = users(:vitcon)
    assert_not sangvo.following?(vitcon)
    sangvo.follow(vitcon)
    assert sangvo.following?(vitcon)
    assert vitcon.followers.include?(sangvo)
    sangvo.unfollow(vitcon)
    assert_not sangvo.following?(vitcon)
  end

  test "feed should have the right posts" do
    michael = users(:sangvo)
    archer  = users(:vitcon)
    lana    = users(:kendy)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
