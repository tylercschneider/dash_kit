# frozen_string_literal: true

module DashKit
  class ConfigurationsController < ApplicationController
    before_action :set_configuration

    def toggle_widget
      @configuration.toggle_widget(params[:widget_key])
      respond_to do |format|
        format.turbo_stream { render_turbo_stream_update }
        format.html { redirect_back fallback_location: main_app.root_path }
      end
    end

    def move_widget
      case params[:direction]
      when "up"
        @configuration.move_widget_up(params[:widget_key])
      when "down"
        @configuration.move_widget_down(params[:widget_key])
      end
      respond_to do |format|
        format.turbo_stream { render_turbo_stream_update }
        format.html { redirect_back fallback_location: main_app.root_path }
      end
    end

    def save_filters
      @configuration.update_filter(params[:filter_key], params[:filter_value])
      head :ok
    end

    def reorder
      new_order = params[:widget_order]
      valid_keys = @configuration.available_widgets.keys.map(&:to_s)

      if new_order.is_a?(Array) && new_order.all? { |k| valid_keys.include?(k) }
        @configuration.update!(widget_order: new_order)
        head :ok
      else
        head :unprocessable_entity
      end
    end

    private

    def render_turbo_stream_update
      render turbo_stream: turbo_stream.replace(
        "dashboard-widgets",
        helpers.dash_kit_render_widgets(config: @configuration)
      )
    end

    def set_configuration
      @configuration = DashKit::Configuration.find(params[:id])
    end
  end
end
