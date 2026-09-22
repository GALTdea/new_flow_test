require "test_helper"

class PublicErrorPagesTest < ActiveSupport::TestCase
  ERROR_PAGES = {
    "400" => "Bad request",
    "404" => "Page not found",
    "422" => "Request cannot be processed",
    "500" => "Something went wrong"
  }.freeze

  test "static error pages are self-contained and accessible" do
    ERROR_PAGES.each do |status, heading|
      document = Nokogiri::HTML.parse(Rails.root.join("public", "#{status}.html").read)

      assert_equal "en", document.at_css("html")["lang"], status
      assert_equal "noindex, nofollow", document.at_css("meta[name='robots']")["content"], status
      assert document.at_css("meta[name='viewport']"), "#{status} has a viewport declaration"
      assert_equal 1, document.css("main").size, status
      assert_equal heading, document.at_css("h1").text.strip, status
      assert_equal 1, document.css("h1").size, status
      assert_equal "/", document.at_css("a")["href"], status
      assert_empty document.css("script"), status
      assert_empty document.css("link[href]"), status
    end
  end
end
