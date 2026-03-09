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

    def move_widget_up(widget_key)
      index = widget_order.index(widget_key.to_s)
      return if index.nil? || index == 0

      new_order = widget_order.dup
      new_order[index], new_order[index - 1] = new_order[index - 1], new_order[index]
      update!(widget_order: new_order)
    end

    def move_widget_down(widget_key)
      index = widget_order.index(widget_key.to_s)
      return if index.nil? || index == widget_order.length - 1

      new_order = widget_order.dup
      new_order[index], new_order[index + 1] = new_order[index + 1], new_order[index]
      update!(widget_order: new_order)
    end
  end
end
