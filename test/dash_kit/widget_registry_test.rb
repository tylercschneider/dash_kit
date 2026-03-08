# frozen_string_literal: true

require "test_helper"

class DashKit::WidgetRegistryTest < Minitest::Test
  def setup
    @registry = DashKit::WidgetRegistry.new
  end

  def test_register_dashboard_with_widgets
    @registry.register(:home) do |d|
      d.widget :on_deck, label: "On Deck", partial: "widgets/home/on_deck"
    end

    widgets = @registry.widgets_for(:home)
    assert_equal 1, widgets.size
    assert_equal "On Deck", widgets[:on_deck][:label]
    assert_equal "widgets/home/on_deck", widgets[:on_deck][:partial]
    assert_equal 1, widgets[:on_deck][:position]
  end

  def test_default_widget_order
    @registry.register(:home) do |d|
      d.widget :on_deck, label: "On Deck", partial: "widgets/home/on_deck"
      d.widget :tasks, label: "Tasks", partial: "widgets/home/tasks"
      d.widget :goals, label: "Goals", partial: "widgets/home/goals"
    end

    order = @registry.default_widget_order(:home)
    assert_equal %w[on_deck tasks goals], order
  end
end
