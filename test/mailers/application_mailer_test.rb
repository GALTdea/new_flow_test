require "test_helper"

class ApplicationMailerTest < ActionMailer::TestCase
  test "uses the centralized application identity" do
    assert_equal Rails.configuration.x.mailer_from, ApplicationMailer.default_params[:from]
    assert_equal Rails.configuration.x.mailer_from, Devise.mailer_sender
  end
end
