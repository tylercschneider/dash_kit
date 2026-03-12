require "dash_kit/version"
require "dash_kit/widget_registry"

module DashKit
  class Error < StandardError; end

  mattr_accessor :parent_controller, default: "DashKit::ApplicationController"

  def self.registry
    @registry ||= WidgetRegistry.new
  end

  def self.configure
    yield registry
  end

  def self.reset_registry!
    @registry = WidgetRegistry.new
  end
end

require "dash_kit/engine" if defined?(Rails::Engine)
