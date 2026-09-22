# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    redirect_to new_user_password_path, alert: "Too many attempts. Please try again later."
  }
end
