require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "renders the starter home page without a product workflow" do
    get root_url

    assert_response :success
    assert_select "title", "#{Rails.configuration.x.application_name} | Home"
    assert_select "h1", "A ready application shell, not a blank generate."
    assert_select ".page-notice", /No domain workflow is included/i
    assert_select ".page-next-step [aria-disabled='true']", "Product workflow is not included"
    assert_select "form", count: 0
    assert_select "input, select, textarea", count: 0
    assert_select ".page-next-step a", count: 0
    assert_select "a[href='#{new_user_session_path}']", "Sign in"
    assert_select "a[href='#{new_user_registration_path}']", "Create account"
  end
end
