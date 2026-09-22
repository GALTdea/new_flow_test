require "test_helper"

class ApplicationLayoutTest < ActionView::TestCase
  test "renders the accessible application shell without empty flash announcements" do
    render inline: "<p>Page content</p>", layout: "layouts/application"

    application_name = Rails.configuration.x.application_name

    assert_select "html[lang='en']"
    assert_select "title", application_name
    assert_select "meta[name='application-name'][content='#{application_name}']"
    assert_select "header[aria-label='#{application_name}']"
    assert_select "a.skip-link[href='#main-content']", "Skip to main content"
    assert_select "a.site-header__brand-link", application_name
    assert_select "nav[aria-label='Account']"
    assert_select "a[href='#{new_user_session_path}']", "Sign in"
    assert_select "a[href='#{new_user_registration_path}']", "Create account"
    assert_select "main#main-content[tabindex='-1']", "Page content"
    assert_select ".flash-messages", count: 0
  end

  test "renders flash messages in the status region" do
    controller.flash[:notice] = "Saved"
    controller.flash[:alert] = "Please review this"

    render inline: "<p>Page content</p>", layout: "layouts/application"

    assert_select ".flash-message--notice[role='status'][aria-atomic='true']", "Saved"
    assert_select ".flash-message--alert[role='alert'][aria-atomic='true']", "Please review this"
  end
end
