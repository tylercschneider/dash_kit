# frozen_string_literal: true

module DashKit
  class ConfigurationsController < ApplicationController
    before_action :set_configuration

    def toggle_widget
      @configuration.toggle_widget(params[:widget_key])
      redirect_back fallback_location: main_app.root_path
    end

    private

    def set_configuration
      @configuration = DashKit::Configuration.find(params[:id])
    end
  end
end
