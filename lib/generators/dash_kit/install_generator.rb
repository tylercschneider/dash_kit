# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module DashKit
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      desc "Install DashKit dashboard engine"

      def copy_migration
        migration_template "create_dash_kit_configurations.rb.tt", "db/migrate/create_dash_kit_configurations.rb"
      end

      def copy_initializer
        template "dash_kit.rb.tt", "config/initializers/dash_kit.rb"
      end

      def mount_engine
        route 'mount DashKit::Engine => "/dash_kit"'
      end

      def print_instructions
        say ""
        say "DashKit installed successfully!", :green
        say ""
        say "Next steps:"
        say "  1. Run migrations: rails db:migrate"
        say "  2. Register your dashboards in config/initializers/dash_kit.rb"
        say ""
      end
    end
  end
end
