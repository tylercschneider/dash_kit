# DashKit

## What DashKit Is

DashKit is a Ruby / Rails UI engine for composing, configuring, and rendering dashboards. It provides a presentation and interaction layer that lets teams build reusable dashboards and widgets without tying the UI to any specific backend or data system.

## What DashKit Is Not

DashKit does **not**:

- Define metrics or their meaning.
- Query databases or execute data retrieval logic.
- Validate metric correctness or enforce business rules.
- Assume any specific backend or analytics engine.

DashKit expects an external data provider to supply datasets. It focuses solely on rendering dashboards from those datasets.

## High-Level Architecture

```
UI events → DataProvider → Dataset → Rendering
```

DashKit turns user intent (filters, time ranges, widget configs) into a request for a data provider, receives a dataset, and renders it into the dashboard UI.

## Dashboards & Widgets

**Dashboard**
- A container for layout, shared filters, and widget configuration.
- Responsible for composition and reuse of dashboard layouts.

**Widget**
- A visual unit (chart, table, single value) backed by a data request.
- Each widget describes what it needs, but does not know how data is fetched.

**Filters and Layouts**
- Filters are passed through as generic values.
- Layout is a configuration concern (positions, sizes, grouping).
- DashKit does not validate filter meaning or enforce data semantics.

## Data Provider Interface

DashKit integrates with any backend through a pluggable data provider. The provider receives normalized requests and returns datasets in a generic structure.

Minimal interface sketch:

```ruby
class MyProvider
  # request is a plain object or hash describing widget intent
  def fetch(request)
    # return a dataset hash
  end
end
```

DashKit does not care how data is fetched. It only requires that the provider responds to requests and returns datasets that match the contract.

## Dataset Contract

DashKit renders datasets with a predictable structure, while leaving meaning and correctness to the provider.

Example dataset:

```json
{
  "series": [
    { "name": "Revenue", "points": [ { "x": "2024-01", "y": 120 } ] }
  ],
  "rows": [ { "label": "Total", "value": 120 } ],
  "meta": { "unit": "USD" }
}
```

DashKit expects:

- Consistent keys and array shapes per widget type.
- Values that can be rendered without additional interpretation.

DashKit does **not** define:

- What series or rows mean.
- Which fields are required beyond a widget’s renderer.
- How values are derived.

## Basic Usage Example

Mounting DashKit:

```ruby
# config/routes.rb
mount DashKit::Engine, at: "/dashboards"
```

Registering a data provider:

```ruby
DashKit.configure do |config|
  config.data_provider = MyProvider.new
end
```

Rendering a simple dashboard:

```ruby
# app/controllers/dashboards_controller.rb
class DashboardsController < ApplicationController
  def show
    @dashboard = DashKit::Dashboard.load("sales")
  end
end
```

## Design Philosophy

DashKit avoids data semantics by design. It treats datasets as opaque structures that can be rendered consistently, allowing teams to replace or evolve backends without rewriting dashboards. This deliberate decoupling keeps DashKit focused, composable, and stable over time.
