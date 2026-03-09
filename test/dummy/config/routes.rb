# frozen_string_literal: true

Rails.application.routes.draw do
  mount DashKit::Engine => "/dash_kit"
end
