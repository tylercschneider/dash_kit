module DashKit
  class Engine < ::Rails::Engine
    isolate_namespace DashKit

    initializer "dash_kit.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
      end
    end
  end
end
