# frozen_string_literal: true

require "test_helper"

class DashKit::ConfigurationTest < ActiveSupport::TestCase
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
  end

  test "ordered_visible_widgets excludes hidden widgets" do
    config = DashKit::Configuration.new(
      owner: @account,
      dashboard_type: "home",
      widget_order: %w[on_deck tasks goals],
      hidden_widgets: %w[tasks]
    )

    assert_equal %w[on_deck goals], config.ordered_visible_widgets
  end

  test "toggle_widget hides a visible widget" do
    config = DashKit::Configuration.create!(
      owner: @account,
      dashboard_type: "home",
      widget_order: %w[on_deck tasks goals],
      hidden_widgets: []
    )

    config.toggle_widget(:tasks)
    assert_includes config.hidden_widgets, "tasks"
  end

  test "toggle_widget shows a hidden widget" do
    config = DashKit::Configuration.create!(
      owner: @account,
      dashboard_type: "home",
      widget_order: %w[on_deck tasks goals],
      hidden_widgets: %w[tasks]
    )

    config.toggle_widget(:tasks)
    refute_includes config.hidden_widgets, "tasks"
  end

  test "move_widget_up swaps with previous widget" do
    config = DashKit::Configuration.create!(
      owner: @account,
      dashboard_type: "home",
      widget_order: %w[on_deck tasks goals],
      hidden_widgets: []
    )

    config.move_widget_up(:tasks)
    assert_equal %w[tasks on_deck goals], config.reload.widget_order
  end

  test "move_widget_up does nothing for first widget" do
    config = DashKit::Configuration.create!(
      owner: @account,
      dashboard_type: "home",
      widget_order: %w[on_deck tasks goals],
      hidden_widgets: []
    )

    config.move_widget_up(:on_deck)
    assert_equal %w[on_deck tasks goals], config.reload.widget_order
  end

  test "move_widget_down swaps with next widget" do
    config = DashKit::Configuration.create!(
      owner: @account,
      dashboard_type: "home",
      widget_order: %w[on_deck tasks goals],
      hidden_widgets: []
    )

    config.move_widget_down(:tasks)
    assert_equal %w[on_deck goals tasks], config.reload.widget_order
  end

  test "move_widget_down does nothing for last widget" do
    config = DashKit::Configuration.create!(
      owner: @account,
      dashboard_type: "home",
      widget_order: %w[on_deck tasks goals],
      hidden_widgets: []
    )

    config.move_widget_down(:goals)
    assert_equal %w[on_deck tasks goals], config.reload.widget_order
  end
end
