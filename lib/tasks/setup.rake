require "erb"

namespace :setup do
  desc "Setup project with custom configuration"
  task :project do
    print "Enter project name (e.g., musicforge.ai): "
    project_name = STDIN.gets.chomp

    if project_name.strip.empty?
      puts "Error: Project name cannot be empty"
      exit 1
    end

    # Rails 风格数据库命名：小写 + 下划线
    db_prefix = project_name.downcase.gsub(/[^a-z0-9]+/, "_").gsub(/^_+|_+$/, "")

    if db_prefix.empty?
      puts "Error: Project name must contain at least one alphanumeric character"
      exit 1
    end

    print "Enter web server IP (leave empty to keep current): "
    web_ip = STDIN.gets.chomp.strip
    web_ip = nil if web_ip.empty?

    print "Configure database accessory? (y/N): "
    configure_db_accessory = STDIN.gets.chomp.strip.downcase == "y"

    db_accessory_host = nil
    db_host = nil

    if configure_db_accessory
      print "Enter database accessory host IP: "
      db_accessory_host = STDIN.gets.chomp.strip
      if db_accessory_host.empty?
        puts "Error: Database accessory host cannot be empty"
        exit 1
      end
    else
      print "Enter database host IP for DB_HOST env (leave empty to keep current): "
      db_host = STDIN.gets.chomp.strip
      db_host = nil if db_host.empty?
    end

    puts "\nConfiguring project: #{project_name}"
    puts "Database prefix: #{db_prefix}"
    puts "Domain: staging.#{project_name}"
    puts "Web server IP: #{web_ip || '(unchanged)'}"
    if configure_db_accessory
      puts "Database accessory: enabled (#{db_accessory_host})"
      puts "Database host: #{db_prefix}-db (via Kamal docker network)"
    else
      puts "Database accessory: disabled"
      puts "Database host: #{db_host || '(unchanged)'}"
    end
    puts ""

    # Render templates
    render_database_config(db_prefix)
    render_deploy_config(project_name, db_prefix, web_ip, db_host, db_accessory_host)
    render_init_sql(db_prefix)

    puts "\n✅ Project setup complete!"
    puts "\nNext steps:"
    puts "1. Run 'bin/setup' to install dependencies and create databases"
    puts "2. Configure your secrets in .kamal/secrets"
    puts "3. Deploy with 'bin/kamal deploy'"
  end

  private

  def render_database_config(db_prefix)
    template_path = Rails.root.join("lib", "templates", "database.yml.tt")
    output_path = Rails.root.join("config", "database.yml")

    unless File.exist?(template_path)
      puts "Error: #{template_path} not found"
      exit 1
    end

    template = File.read(template_path)
    result = ERB.new(template, trim_mode: "-").result(binding)
    File.write(output_path, result)

    puts "✓ Updated database.yml"
  end

  def render_deploy_config(project_name, db_prefix, web_ip, db_host, db_accessory_host)
    template_path = Rails.root.join("lib", "templates", "deploy.yml.tt")
    output_path = Rails.root.join("config", "deploy.yml")

    unless File.exist?(template_path)
      puts "Error: #{template_path} not found"
      exit 1
    end

    template = File.read(template_path)
    result = ERB.new(template, trim_mode: "-").result(binding)
    File.write(output_path, result)

    puts "✓ Updated deploy.yml"
  end

  def render_init_sql(db_prefix)
    output_path = Rails.root.join("config", "init.sql")
    sql = <<~SQL
      -- Managed by `rake setup:project`
      CREATE DATABASE #{db_prefix}_production_cache;
      CREATE DATABASE #{db_prefix}_production_queue;
      CREATE DATABASE #{db_prefix}_production_cable;
    SQL

    File.write(output_path, sql)

    puts "✓ Updated init.sql"
  end
end
