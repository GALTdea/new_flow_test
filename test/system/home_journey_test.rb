require "application_system_test_case"

class HomeJourneyTest < ApplicationSystemTestCase
  test "visitor can understand the starter boundaries without entering data" do
    visit root_url

    assert_selector "h1", text: "A ready application shell, not a blank generate."
    assert_text "No domain workflow is included"
    assert_selector ".unavailable-action[aria-disabled='true']", text: "Product workflow is not included"
    assert_no_selector "form"
    assert_no_selector "input, select, textarea"
  end
end
