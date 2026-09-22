class ApplicationController < ActionController::Base
  include Authentication

  before_action :authenticate_user!, unless: :devise_controller?

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
