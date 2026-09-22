require "test_helper"

class Development::UiControllerTest < ActionDispatch::IntegrationTest
  test "renders canonical primitives and associated form errors" do
    get development_ui_path

    assert_response :success
    assert_select "main"
    assert_select "h1#ui-showcase-title", "UI showcase"
    assert_select ".flash-message--notice[role='status']", "Your changes were saved."
    assert_select ".flash-message--alert[role='alert']", "Please review the highlighted fields."
    assert_select ".empty-state h2#example-empty-state-title", "Nothing here yet"
    assert_select ".error-state[role='alert'] h2#example-error-state-title", "We could not load this information"
    assert_select ".form-errors#example-form-errors[role='alert']"
    assert_select "input#user_email[aria-invalid='true'][aria-describedby='user_email_hint user_email_error']"
    assert_select "#user_email_error", "Email is invalid"
    assert_select "input#user_password[aria-invalid='true'][aria-describedby='user_password_hint user_password_error']"
    assert_select "#user_password_error", /Password is too short/
  end
end
