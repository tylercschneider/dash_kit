# frozen_string_literal: true

module DashKit
  module DashboardHelper
    def dash_kit_widget_label(config, widget_key)
      config.available_widgets.dig(widget_key.to_sym, :label) || widget_key.to_s.humanize
    end

    def dash_kit_render_widgets(config:)
      return "".html_safe unless config

      safe_join(
        config.ordered_visible_widgets.filter_map do |widget_key|
          widget_def = config.available_widgets[widget_key.to_sym]
          next unless widget_def

          dash_kit_widget_frame(widget_key)
        end
      )
    end

    def dash_kit_widget_frame(widget_key, &block)
      src = dash_kit.widget_path(widget_key)
      id = "widget_#{widget_key}"
      loading_content = block ? capture(&block) : dash_kit_loading_skeleton

      content_tag("turbo-frame", loading_content, id: id, src: src, loading: "lazy", target: "_top")
    end

    def dash_kit_loading_skeleton
      content_tag(:div, class: "animate-pulse") do
        safe_join([
          content_tag(:div, "", class: "h-5 bg-gray-200 rounded w-1/3 mb-4"),
          content_tag(:div, class: "space-y-3") do
            safe_join([
              content_tag(:div, "", class: "h-4 bg-gray-200 rounded w-full"),
              content_tag(:div, "", class: "h-4 bg-gray-200 rounded w-5/6"),
              content_tag(:div, "", class: "h-4 bg-gray-200 rounded w-4/6")
            ])
          end
        ])
      end
    end
  end
end
