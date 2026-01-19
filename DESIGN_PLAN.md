# DashKit Design Plan

## Problem Statement

Dashboards often become tightly coupled to specific data systems. UI layers end up embedding assumptions about how data is fetched, what metrics mean, or which backend is authoritative. Over time, this coupling makes it hard to replace data systems, evolve metric definitions, or reuse dashboard layouts across contexts.

DashKit exists to keep the UI layer stable and reusable by treating data as an external concern.

## Design Goals

- **Backend agnosticism:** DashKit should not depend on any specific data system.
- **Composability:** Dashboards and widgets should be reusable and configurable.
- **Replaceability:** Data providers can be swapped without rewriting dashboards.
- **Simplicity:** The contract between UI and data should be minimal and clear.

## Core Objects

### DashKit::Dashboard
- Owns layout configuration and shared filters.
- Defines which widgets are present and how they are arranged.

### DashKit::Widget
- A visual unit (chart, table, single value) that declares its data needs.
- Contains configuration for rendering, not for data meaning.

### DashKit::DataProvider
- A pluggable object responsible for fulfilling data requests.
- Receives a request and returns a dataset.

### DashKit::Dataset
- A generic, backend-agnostic structure used for rendering.
- Treated as opaque by DashKit beyond required shape for rendering.

## Execution Flow

```
User interaction → request generation → provider call → dataset → render
```

1. User changes filters or loads a dashboard.
2. DashKit generates a request from dashboard and widget config.
3. The data provider receives the request and returns a dataset.
4. DashKit renders the dataset in the widget.

## Data Provider Contract

**Required methods**

- `fetch(request)` → returns a dataset object or hash.

**Responsibilities**

- Translate DashKit requests into backend-specific calls.
- Return datasets that match the widget’s expected shape.

**Explicit boundaries**

- DashKit does not inspect how data is fetched.
- DashKit does not execute queries or validate meaning.

## Dataset Contract

**Required fields**

- The dataset must provide the keys expected by the widget renderer.
- Common keys might include `series`, `rows`, or `meta`, but DashKit does not enforce semantics.

**Rendering expectations**

- Values should be ready to render without additional interpretation.
- Missing keys result in rendering gaps, not implicit corrections.

**Why DashKit does not enforce meaning**

- Meaning belongs to the data provider and the system that owns metric definitions.
- DashKit stays stable by rendering shapes, not semantics.

## Filter Handling

- Filters are represented as plain values (strings, numbers, ranges, or hashes).
- DashKit passes filters through to the data provider without validation.
- Validation and enforcement belong to the provider or calling system.

## Non-Goals

DashKit will never:

- Execute data retrieval logic.
- Interpret metric semantics or enforce business rules.
- Depend on a specific backend or analytics system.
- Own data correctness.

## Extensibility (Non-Promissory)

Possible future extensions (not commitments):

- Additional widget types (e.g., new chart shapes or layout variants).
- Integration adapters for different data providers.

These are intentionally left open and do not represent a roadmap.
