require "application_system_test_case"

class AuthenticationJourneyTest < ApplicationSystemTestCase
  test "visitor can create a confirmed account, open settings, and sign out" do
    visit root_url
    click_link "Create account", href: new_user_registration_path

    fill_in "Email", with: "starter@example.com"
    fill_in "user_password", with: TEST_PASSWORD
    fill_in "user_password_confirmation", with: TEST_PASSWORD
    click_button "Create account"

    assert_text(/confirmation link has been sent/i)

    token = extract_email_token(ActionMailer::Base.deliveries.last, "confirmation_token")
    visit user_confirmation_url(confirmation_token: token)

    assert_selector "h1", text: "Sign in"
    fill_in "Email", with: "starter@example.com"
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    assert_text "Signed in successfully."
    visit edit_user_registration_url
    assert_selector "h1", text: "Account settings"
    assert_text(/manage the email and password used to sign in/i)
    assert_no_text "Cancel my account"

    click_button "Sign out"
    assert_text(/signed out/i)
    assert_link "Sign in", href: new_user_session_path
    assert_link "Create account", href: new_user_registration_path
  end

  test "visitor receives accessible feedback when registration is invalid" do
    visit new_user_registration_url

    fill_in "Email", with: users(:confirmed).email
    fill_in "user_password", with: TEST_PASSWORD
    fill_in "user_password_confirmation", with: "different-password"
    click_button "Create account"

    assert_selector ".form-errors[role='alert']"
    assert_text(/password confirmation doesn't match/i)
    assert_selector "input#user_password_confirmation[aria-invalid='true'][aria-describedby='user_password_confirmation_error']"
    assert_selector "#user_password_confirmation_error", text: /password confirmation doesn't match/i
  end
end
