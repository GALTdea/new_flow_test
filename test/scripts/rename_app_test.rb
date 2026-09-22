require "test_helper"
require "fileutils"
require "open3"
require "rbconfig"
require "tmpdir"

class RenameAppTest < ActiveSupport::TestCase
  def setup
    @root = Dir.mktmpdir("rename-app-test")
    write_template_files
    FileUtils.mkdir_p(File.join(@root, "bin"))
    FileUtils.cp(Rails.root.join("bin/rename_app"), File.join(@root, "bin/rename_app"))
  end

  def teardown
    FileUtils.remove_entry(@root)
  end

  test "renames only known application and operational identifiers" do
    stdout, stderr, status = run_rename("--name", "Acme Portal", "--identifier", "acme_portal")

    assert_predicate status, :success?, stderr
    assert_match "Renamed application configuration", stdout
    assert_equal "module AcmePortal\nname = \"Acme Portal\"\n", read("config/application.rb")
    assert_equal "database: acme_portal_development\npassword: ENV[\"ACME_PORTAL_DATABASE_PASSWORD\"]\n", read("config/database.yml")
    assert_equal "service: acme_portal\n", read("config/deploy.yml")
    assert_equal "docker build -t acme_portal .\nMAILER_FROM=\"Acme Portal <noreply@build.invalid>\"\n", read("Dockerfile")
  end

  test "shows a plan without writing files in dry-run mode" do
    original = read("config/application.rb")

    stdout, stderr, status = run_rename("--name", "Acme Portal", "--identifier", "acme_portal", "--dry-run")

    assert_predicate status, :success?, stderr
    assert_match "Would rename Starter App", stdout
    assert_equal original, read("config/application.rb")
  end

  test "rejects unsafe operational identifiers" do
    _stdout, stderr, status = run_rename("--name", "Acme Portal", "--identifier", "Acme Portal")

    assert_not_predicate status, :success?
    assert_match "lowercase snake_case", stderr
  end

  private

  def run_rename(*arguments)
    Open3.capture3(RbConfig.ruby, File.join(@root, "bin/rename_app"), *arguments)
  end

  def write_template_files
    write("config/application.rb", "module StarterApp\nname = \"Starter App\"\n")
    write("config/database.yml", "database: starter_app_development\npassword: ENV[\"STARTER_APP_DATABASE_PASSWORD\"]\n")
    write("config/deploy.yml", "service: starter_app\n")
    write("Dockerfile", "docker build -t starter_app .\nMAILER_FROM=\"Starter App <noreply@build.invalid>\"\n")
  end

  def write(relative_path, content)
    path = File.join(@root, relative_path)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, content)
  end

  def read(relative_path)
    File.read(File.join(@root, relative_path))
  end
end
