# frozen_string_literal: true

module DashKit
  class Configuration < ApplicationRecord
    self.table_name = "dash_kit_configurations"

    belongs_to :owner, polymorphic: true

    validates :dashboard_type, presence: true

    def ordered_visible_widgets
      widget_order.reject { |w| hidden_widgets.include?(w) }
    end

    def toggle_widget(widget_key)
      key = widget_key.to_s
      self.hidden_widgets = if hidden_widgets.include?(key)
        hidden_widgets - [key]
      else
        hidden_widgets + [key]
      end
      save!
    end
  end
end
