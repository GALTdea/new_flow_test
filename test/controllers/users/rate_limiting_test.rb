require "test_helper"

class Users::RateLimitingTest < ActionDispatch::IntegrationTest
  setup do
    ActionController::Base.cache_store.clear
  end

  test "limits repeated authentication submissions by remote address" do
    assert_rate_limited(
      user_registration_path,
      new_user_registration_path,
      { user: { email: "not-an-email", password: "short", password_confirmation: "different" } },
      "198.51.100.1"
    )
    assert_rate_limited(
      user_session_path,
      new_user_session_path,
      { user: { email: users(:confirmed).email, password: "wrong-password" } },
      "198.51.100.2"
    )
    assert_rate_limited(
      user_password_path,
      new_user_password_path,
      { user: { email: "missing@example.com" } },
      "198.51.100.3"
    )
    assert_rate_limited(
      user_confirmation_path,
      new_user_confirmation_path,
      { user: { email: "missing@example.com" } },
      "198.51.100.4"
    )
  end

  private

  def assert_rate_limited(path, redirect_path, params, remote_ip)
    10.times do
      post path, params: params, env: { "REMOTE_ADDR" => remote_ip }
    end

    post path, params: params, env: { "REMOTE_ADDR" => remote_ip }

    assert_redirected_to redirect_path
    assert_match(/too many attempts/i, flash[:alert])
  end
end
