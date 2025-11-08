# frozen_string_literal: true

require "rails/generators/base"
require "fileutils"

module RailsMultitenantSignupFlow
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      class_option :force, type: :boolean, default: false, desc: "Overwrite existing files"

      def ensure_authentication_scaffold
        return if authentication_generated?

        say_status :invoke, "rails generate authentication", :green
        rails_command "generate authentication"
        move_authentication_migrations_to_global
      end

      def copy_sessions_controller
        template "sessions_controller.rb.tt", "app/controllers/sessions_controller.rb", force: force?
      end

      def copy_sign_ups_controller
        template "sign_ups_controller.rb.tt", "app/controllers/sign_ups_controller.rb", force: force?
      end

      def copy_sign_up_view
        template "sign_ups_show.html.erb.tt", "app/views/sign_ups/show.html.erb", force: force?
      end

      def copy_global_record
        template "global_record.rb.tt", "app/models/global_record.rb", force: force?
      end

      def copy_host_url_concern
        template "host_url.rb.tt", "app/controllers/concerns/host_url.rb", force: force?
      end

      def copy_tenant_service
        template "tenant_service.rb.tt", "lib/tenant_service.rb", force: force?
      end

      def copy_tenant_model
        template "tenant.rb.tt", "app/models/tenant.rb", force: force?
      end

      def copy_user_model
        template "user.rb.tt", "app/models/user.rb", force: force?
      end

      def copy_session_model
        template "session.rb.tt", "app/models/session.rb", force: force?
      end

      def configure_application_record
        path = "app/models/application_record.rb"
        if File.exist?(path)
          ensure_tenanted_in_application_record(path)
        else
          say_status :missing, path, :yellow
          create_default_application_record(path)
        end
      end

      def configure_database
        template "database.yml.tt", "config/database.yml", force: force?
      end

      def ensure_sign_up_route
        routes_path = "config/routes.rb"
        return unless File.exist?(routes_path)

        content = File.read(routes_path)
        return if content.include?("resource :sign_up")

        route "resource :sign_up, only: [:show, :create]"
      end

      def generate_tenant_migrations
        say_status :invoke, "rails generate migration CreateTenants", :green
        rails_command "generate migration CreateTenants name:string --database=global"

        say_status :invoke, "rails generate migration AddTenantToUsers", :green
        rails_command "generate migration AddTenantToUsers tenant:references --database=global"

        modify_add_tenant_to_users_migration
      end

      private

      def authentication_generated?
        File.exist?("app/models/user.rb") && File.read("app/models/user.rb").match?(/has_secure_password/)
      rescue Errno::ENOENT
        false
      end

      def ensure_tenanted_in_application_record(path)
        contents = File.read(path)
        return if contents.include?("tenanted")

        if contents.match?(/primary_abstract_class/)
          gsub_file path, /primary_abstract_class\s*\n/, "primary_abstract_class\n  tenanted\n"
        else
          inject_into_class path, "ApplicationRecord", "  tenanted\n"
        end
      end

      def create_default_application_record(path)
        create_file path, <<~RUBY, force: force?
          class ApplicationRecord < ActiveRecord::Base
            primary_abstract_class
            tenanted
          end
        RUBY
      end

      def force?
        options[:force]
      end

      def move_authentication_migrations_to_global
        Dir.glob("db/migrate/*_create_users.rb").each do |file|
          move_migration file
        end

        Dir.glob("db/migrate/*_create_sessions.rb").each do |file|
          move_migration file
        end
      end

      def move_migration(file)
        destination = file.gsub("db/migrate", "db/global_migrate")
        FileUtils.mkdir_p("db/global_migrate")
        FileUtils.mv(file, destination)
        say_status :move, "#{file} -> #{destination}", :green
      end

      def modify_add_tenant_to_users_migration
        migration_file = Dir.glob("db/global_migrate/*_add_tenant_to_users.rb").max_by { |f| File.mtime(f) }
        return unless migration_file

        content = File.read(migration_file)

        new_content = content.gsub(
          /def change\s*\n\s*add_reference :users, :tenant.*?\n\s*end/m,
          <<~RUBY.strip
            def change
              add_reference :users, :tenant, null: true, foreign_key: true

              # Create a default tenant using SQL
              execute <<-SQL
                INSERT INTO tenants (name, created_at, updated_at) VALUES ('default', datetime('now'), datetime('now'))
              SQL

              # Assign all existing users to the default tenant (id=1 since it's the first)
              execute <<-SQL
                UPDATE users SET tenant_id = 1
              SQL

              # Make the column NOT NULL
              change_column_null :users, :tenant_id, false
            end
          RUBY
        )

        File.write(migration_file, new_content)
        say_status :modify, migration_file, :yellow
      end
    end
  end
end
