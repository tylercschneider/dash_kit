require "dash_kit/version"
require "dash_kit/widget_registry"

module DashKit
  class Error < StandardError; end
end

require "dash_kit/engine" if defined?(Rails::Engine)
