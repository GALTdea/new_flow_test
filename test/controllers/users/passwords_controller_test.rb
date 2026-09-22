require "test_helper"

class Users::PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "sends reset instructions for a known email" do
    assert_difference "ActionMailer::Base.deliveries.size", 1 do
      post user_password_path, params: { user: { email: users(:confirmed).email } }
    end

    assert_redirected_to new_user_session_path
  end

  test "uses the same copy when the email is unknown" do
    assert_no_difference "ActionMailer::Base.deliveries.size" do
      post user_password_path, params: { user: { email: "missing@example.com" } }
    end

    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_match(/if your email address exists/i, flash[:notice])
  end

  test "resets the password from a mailed token" do
    post user_password_path, params: { user: { email: users(:confirmed).email } }
    token = extract_email_token(ActionMailer::Base.deliveries.last, "reset_password_token")

    put user_password_path, params: {
      user: {
        reset_password_token: token,
        password: "newpassword123",
        password_confirmation: "newpassword123"
      }
    }

    assert_redirected_to root_path
    users(:confirmed).reload
    assert users(:confirmed).valid_password?("newpassword123")
  end

  test "renders an error when the reset token is invalid" do
    put user_password_path, params: {
      user: {
        reset_password_token: "not-a-valid-token",
        password: "newpassword123",
        password_confirmation: "newpassword123"
      }
    }

    assert_response :unprocessable_content
    assert users(:confirmed).valid_password?(TEST_PASSWORD)
    assert_select ".form-errors[role='alert']", /Reset password token is invalid/
  end
end
