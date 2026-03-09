# frozen_string_literal: true

Rails.application.routes.draw do
  mount DashKit::Engine => "/dash_kit"

  root to: proc { [ 200, {}, [ "OK" ] ] }
end
