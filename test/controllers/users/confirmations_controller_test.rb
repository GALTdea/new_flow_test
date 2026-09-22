require "test_helper"

class Users::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "confirms an account from the emailed token" do
    post user_registration_path, params: {
      user: {
        email: "confirm-me@example.com",
        password: TEST_PASSWORD,
        password_confirmation: TEST_PASSWORD
      }
    }
    token = extract_email_token(ActionMailer::Base.deliveries.last, "confirmation_token")

    get user_confirmation_path, params: { confirmation_token: token }

    user = User.find_by!(email: "confirm-me@example.com")
    assert user.confirmed?
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_match(/confirmed/i, flash[:notice])
  end

  test "does not confirm an account from an invalid token" do
    get user_confirmation_path, params: { confirmation_token: "not-a-valid-token" }

    assert_response :success
    assert_not users(:unconfirmed).reload.confirmed?
    assert_select ".form-errors[role='alert']", /Confirmation token is invalid/
  end
end
