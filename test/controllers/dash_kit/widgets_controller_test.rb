# frozen_string_literal: true

require "test_helper"

class DashKit::WidgetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    DashKit.reset_registry!
    DashKit.configure do |config|
      config.register(:home) do |d|
        d.widget :on_deck, label: "On Deck", partial: "widgets/home/on_deck"
      end
    end
  end

  test "show renders widget partial" do
    get dash_kit.widget_path(:on_deck)
    assert_response :success
    assert_match "On Deck Widget", response.body
  end

  test "show returns 404 for unknown widget" do
    get dash_kit.widget_path(:nonexistent)
    assert_response :not_found
  end
end
