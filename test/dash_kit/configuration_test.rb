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
end
