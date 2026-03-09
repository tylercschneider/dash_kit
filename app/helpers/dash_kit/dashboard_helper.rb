# frozen_string_literal: true

module DashKit
  module DashboardHelper
    def dash_kit_widget_label(config, widget_key)
      config.available_widgets.dig(widget_key.to_sym, :label) || widget_key.to_s.humanize
    end
  end
end
