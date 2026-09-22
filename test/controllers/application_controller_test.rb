require "test_helper"

class ApplicationControllerTest < ActiveSupport::TestCase
  test "requires authentication for non-Devise controllers by default" do
    callback = ApplicationController._process_action_callbacks.find do |candidate|
      candidate.kind == :before && candidate.filter == :authenticate_user!
    end

    assert callback
  end
end
