module Development
  class UiController < ApplicationController
    skip_before_action :authenticate_user!

    def show
      @example_user = User.new(email: "not-an-email")
      @example_user.errors.add(:email, "is invalid")
      @example_user.errors.add(:password, "is too short (minimum is 8 characters)")
    end
  end
end
