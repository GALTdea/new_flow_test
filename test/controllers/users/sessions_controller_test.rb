require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "renders sign in without requiring an existing session" do
    get new_user_session_path

    assert_response :success
    assert_select "h1", "Sign in"
    assert_select "form[action='#{user_session_path}']"
    assert_select "a", "Create an account"
  end

  test "signs in a confirmed user" do
    post user_session_path, params: {
      user: { email: users(:confirmed).email, password: TEST_PASSWORD }
    }

    assert_redirected_to root_path
    follow_redirect!

    assert_select "a", "Account"
    assert_select ".site-header__sign-out", "Sign out"
  end

  test "does not sign in an unconfirmed user" do
    post user_session_path, params: {
      user: { email: users(:unconfirmed).email, password: TEST_PASSWORD }
    }

    assert_redirected_to new_user_session_path
    assert_match(/confirm your email/i, flash[:alert])
    get edit_user_registration_path
    assert_redirected_to new_user_session_path
  end

  test "does not sign in with an invalid password" do
    post user_session_path, params: {
      user: { email: users(:confirmed).email, password: "not-the-password" }
    }

    assert_response :unprocessable_content
    assert_match(/invalid email or password/i, flash[:alert])
    assert_select ".flash-message--alert[role='alert']", /Invalid email or password/
    get edit_user_registration_path
    assert_redirected_to new_user_session_path
  end

  test "signs out" do
    sign_in users(:confirmed)

    delete destroy_user_session_path

    assert_redirected_to root_path
    follow_redirect!
    assert_select "a", "Sign in"
  end
end
