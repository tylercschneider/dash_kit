# frozen_string_literal: true

require "test_helper"

class DashKit::ConfigTest < ActiveSupport::TestCase
  test "parent_controller defaults to DashKit::ApplicationController" do
    assert_equal "DashKit::ApplicationController", DashKit.parent_controller
  end
end
