# frozen_string_literal: true

module DashKit
  class WidgetsController < ApplicationController
    def show
      widget_key = params[:id].to_sym
      widget_def = find_widget_definition(widget_key)

      if widget_def.nil?
        head :not_found
      else
        render partial: widget_def[:partial], layout: false
      end
    end

    private

    def find_widget_definition(key)
      DashKit.registry.dashboard_types.each do |type|
        widgets = DashKit.registry.widgets_for(type)
        return widgets[key] if widgets.key?(key)
      end
      nil
    end
  end
end
