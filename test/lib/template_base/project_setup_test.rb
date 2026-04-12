require "test_helper"
require "tmpdir"

class TemplateBase::ProjectSetupTest < ActiveSupport::TestCase
  test "renders configuration files and seeds overrides" do
    Dir.mktmpdir do |dir|
      setup = TemplateBase::ProjectSetup.new(
        root: dir,
        project_slug: "starter_app",
        application_name: "Starter App",
        domain: "app.example.test",
        support_email: "support@app.example.test",
        default_from_email: "Starter App <no-reply@app.example.test>",
        web_ip: "10.0.0.2"
      )

      setup.run

      assert_includes File.read(File.join(dir, "config", "database.yml")), "starter_app_development"
      assert_includes File.read(File.join(dir, "config", "deploy.yml")), "host: app.example.test"
      assert_includes File.read(File.join(dir, "config", "template_base.rb")), '"application_name" => "Starter App"'
      assert File.exist?(File.join(dir, "app", "views", "layouts", "application.html.erb"))
      assert File.exist?(File.join(dir, "app", "views", "home", "show.html.erb"))
    end
  end
end
