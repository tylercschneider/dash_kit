# frozen_string_literal: true

module DashKit
  class WidgetRegistry
    def initialize
      @dashboards = {}
    end

    def register(dashboard_type, &block)
      builder = DashboardBuilder.new
      block.call(builder)
      @dashboards[dashboard_type.to_sym] = builder.widgets.freeze
    end

    def widgets_for(dashboard_type)
      @dashboards.fetch(dashboard_type.to_sym)
    end
  end

  class DashboardBuilder
    attr_reader :widgets

    def initialize
      @widgets = {}
      @position = 0
    end

    def widget(key, label:, partial:, **options)
      @position += 1
      @widgets[key.to_sym] = {label: label, partial: partial, position: @position}.merge(options)
    end
  end
end
