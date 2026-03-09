# frozen_string_literal: true

require "test_helper"

class DashKit::DashboardHelperTest < ActionView::TestCase
  include DashKit::DashboardHelper
  include DashKit::Engine.routes.url_helpers

  setup do
    DashKit.reset_registry!
    DashKit.configure do |config|
      config.register(:home) do |d|
        d.widget :on_deck, label: "On Deck", partial: "widgets/home/on_deck"
        d.widget :tasks, label: "Tasks", partial: "widgets/home/tasks"
      end
    end

    @account = Account.create!(name: "Test")
    @config = DashKit::Configuration.create!(
      owner: @account,
      dashboard_type: "home",
      widget_order: %w[on_deck tasks],
      hidden_widgets: []
    )
  end

  test "widget_label returns label from registry" do
    assert_equal "On Deck", dash_kit_widget_label(@config, :on_deck)
  end

  test "widget_label returns humanized key for unknown widget" do
    assert_equal "Unknown", dash_kit_widget_label(@config, :unknown)
  end
end
