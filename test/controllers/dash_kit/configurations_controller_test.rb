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

  test "reorder updates widget order with valid keys" do
    post dash_kit.reorder_configuration_path(@config),
      params: { widget_order: %w[goals tasks on_deck] }

    assert_response :ok
    assert_equal %w[goals tasks on_deck], @config.reload.widget_order
  end

  test "reorder rejects invalid keys" do
    post dash_kit.reorder_configuration_path(@config),
      params: { widget_order: %w[goals fake_widget] }

    assert_response :unprocessable_entity
    assert_equal %w[on_deck tasks goals], @config.reload.widget_order
  end

  test "save_filters updates filter state" do
    post dash_kit.save_filters_configuration_path(@config),
      params: { filter_key: "time_period", filter_value: "last_7_days" }

    assert_response :ok
    assert_equal "last_7_days", @config.reload.filter_state["time_period"]
  end
end
