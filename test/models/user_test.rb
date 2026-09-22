require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes email" do
    user = User.create!(
      email: "  New.User@Example.COM  ",
      password: TEST_PASSWORD,
      password_confirmation: TEST_PASSWORD
    )

    assert_equal "new.user@example.com", user.email
  end
end
