require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "creates an unconfirmed account and sends a confirmation email" do
    assert_difference -> { User.count } => 1, -> { ActionMailer::Base.deliveries.size } => 1 do
      post user_registration_path, params: {
        user: {
          email: "starter@example.com",
          password: TEST_PASSWORD,
          password_confirmation: TEST_PASSWORD
        }
      }
    end

    user = User.find_by!(email: "starter@example.com")
    assert_not user.confirmed?
    assert_redirected_to root_path
    follow_redirect!
    assert_match(/confirm/i, flash[:notice])
    assert_select "a", "Sign in"
  end

  test "requires sign in to view account settings" do
    get edit_user_registration_path

    assert_redirected_to new_user_session_path
  end

  test "renders accessible validation feedback when sign up fails" do
    assert_no_difference "User.count" do
      post user_registration_path, params: {
        user: {
          email: "not-an-email",
          password: TEST_PASSWORD,
          password_confirmation: "different-password"
        }
      }
    end

    assert_response :unprocessable_content
    assert_select ".form-errors[role='alert']", /Email is invalid/
    assert_select "input#user_email[aria-invalid='true'][aria-describedby='user_email_error']"
    assert_select "#user_email_error", "Email is invalid"
    assert_select "input#user_password_confirmation[aria-invalid='true'][aria-describedby='user_password_confirmation_error']"
  end

  test "updates the password with the current password" do
    sign_in users(:confirmed)
    get edit_user_registration_path

    patch user_registration_path, params: {
      user: {
        email: users(:confirmed).email,
        password: "newpassword123",
        password_confirmation: "newpassword123",
        current_password: TEST_PASSWORD
      }
    }

    assert_redirected_to edit_user_registration_path
    assert users(:confirmed).reload.valid_password?("newpassword123")
  end

  test "keeps the current email until a change is reconfirmed" do
    sign_in users(:confirmed)
    get edit_user_registration_path

    patch user_registration_path, params: {
      user: {
        email: "alex.new@example.com",
        current_password: TEST_PASSWORD
      }
    }

    user = users(:confirmed).reload
    assert_equal "alex@example.com", user.email
    assert_equal "alex.new@example.com", user.unconfirmed_email
  end

  test "does not update account settings without the current password" do
    sign_in users(:confirmed)

    patch user_registration_path, params: {
      user: {
        email: "changed@example.com",
        current_password: "not-the-current-password"
      }
    }

    assert_response :unprocessable_content
    assert_equal "alex@example.com", users(:confirmed).reload.email
    assert_select ".form-errors[role='alert']", /Current password is invalid/
    assert_select "input#user_current_password[aria-invalid='true'][aria-describedby='user_current_password_hint user_current_password_error']"
    assert_select "#user_current_password_error", "Current password is invalid"
  end

  test "keeps the home page public while signed in" do
    sign_in users(:confirmed)
    get root_url

    assert_response :success
    assert_select "h1", "A ready application shell, not a blank generate."
  end

  test "does not expose account deletion" do
    assert_raises(ActionController::RoutingError) do
      Rails.application.routes.recognize_path("/users", method: :delete)
    end
  end
end
