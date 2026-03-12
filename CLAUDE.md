# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DashKit is a Rails engine gem for composable, configurable dashboards. It provides a presentation layer — register widgets, persist user configuration (visibility, order, filters), and render dashboards without coupling to any specific data backend.

## Commands

```bash
bundle install                    # Install dependencies
bundle exec rake test             # Run all tests
bundle exec rake test TEST=test/path/to/test.rb  # Run a single test file
bundle exec bin/rubocop           # Lint (rubocop-rails-omakase)
rake dash_kit:claude              # Append DashKit API reference to consuming app's CLAUDE.md
```

## Architecture

This is a Rails engine (`DashKit::Engine`) with an isolated namespace. Key layers:

1. **Dashboard** (`lib/dash_kit/dashboard.rb`) — Defines a dashboard layout and its widget slots.
2. **Widget** (`lib/dash_kit/widget.rb`) — A visual unit that declares its data needs. Widgets don't fetch data themselves.
3. **WidgetRegistry** (`lib/dash_kit/widget_registry.rb`) — Global registry mapping dashboard types to their available widgets.
4. **Configuration** (`app/models/dash_kit/configuration.rb`) — ActiveRecord model persisting user preferences (widget visibility, order, filters) via JSON columns. Polymorphic `owner` association attaches config to any model.

### Data flow

UI events → Configuration update → Turbo refresh → Widgets re-render via lazy-loaded Turbo Frames.

### Routes (mounted at `/dash_kit`)

- `POST /configurations/:id/toggle_widget` — show/hide a widget
- `POST /configurations/:id/move_widget` — reorder a single widget
- `POST /configurations/:id/reorder` — batch reorder with hidden_widgets
- `POST /configurations/:id/save_filters` — persist filter state
- `GET /widgets/:id` — render an individual widget

### JavaScript

Stimulus controllers shipped via importmap (no Node.js):
- `SortableListController` — client-side widget toggles and drag reordering with batched saves on modal close.

## Dependencies

- Rails >= 7.1, Turbo Rails, `keystone_ui` (ViewComponent-based UI)
- Dev: SQLite, Puma, Minitest, rubocop-rails-omakase

## Testing

Uses Minitest with a dummy Rails app (`test/dummy/`). Transactional tests against SQLite.

## Key Conventions

- Ruby >= 3.2
- Tailwind CSS for styling (dark mode support)
- Mobile-first — primary UI is often a native webview
- Widgets are lazy-loaded via `<turbo-frame>` elements
- Settings modal allows users to customize their dashboard
