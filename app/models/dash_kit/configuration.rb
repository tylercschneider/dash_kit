# frozen_string_literal: true

module DashKit
  class Configuration < ApplicationRecord
    self.table_name = "dash_kit_configurations"

    belongs_to :owner, polymorphic: true

    validates :dashboard_type, presence: true

    def ordered_visible_widgets
      widget_order.reject { |w| hidden_widgets.include?(w) }
    end
  end
end
