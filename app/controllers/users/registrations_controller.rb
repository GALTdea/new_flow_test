# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    redirect_to new_user_registration_path, alert: "Too many attempts. Please try again later."
  }

  protected

  def after_update_path_for(_resource)
    edit_user_registration_path
  end

  def after_inactive_sign_up_path_for(_resource)
    root_path
  end
end
