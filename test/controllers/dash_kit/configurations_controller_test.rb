# frozen_string_literal: true

require "test_helper"

class DashKit::ConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    DashKit.reset_registry!
    DashKit.configure do |config|
      config.register(:home) do |d|
        d.widget :on_deck, label: "On Deck", partial: "widgets/home/on_deck"
        d.widget :tasks, label: "Tasks", partial: "widgets/home/tasks"
        d.widget :goals, label: "Goals", partial: "widgets/home/goals"
      end
    end

    @account = Account.create!(name: "Test")
    @config = DashKit::Configuration.create!(
      owner: @account,
      dashboard_type: "home",
      widget_order: %w[on_deck tasks goals],
      hidden_widgets: []
    )
  end

  test "toggle_widget hides a visible widget" do
    post dash_kit.toggle_widget_configuration_path(@config),
      params: { widget_key: "tasks" }

    assert_response :redirect
    @config.reload
    assert_includes @config.hidden_widgets, "tasks"
  end
end
