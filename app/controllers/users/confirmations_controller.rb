# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    redirect_to new_user_confirmation_path, alert: "Too many attempts. Please try again later."
  }

  protected

  def after_confirmation_path_for(_resource_name, _resource)
    new_user_session_path
  end
end
