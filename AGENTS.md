# Starter App

This repository is a Rails 8 starter kit. The code namespace is `StarterApp`. Keep it product-free until a derived application has committed product context.

## Derived applications

Before product work, run `bin/rename_app` and follow the README handoff checklist. Replace the starter identity and product-boundary sections of this file, then add product context under `docs/product/`. Retain and update the capability, architecture, UI, and verification guidance because it describes inherited code.

## Start here

Read the smallest relevant set of project documents before changing behavior:

- [Capabilities](docs/capabilities.md) — current infrastructure, readiness, boundaries, and relevant paths.
- [System overview](docs/architecture/system-overview.md) — application shape and operational boundaries.
- [Verification](docs/process/verification.md) — commands and risk-driven evidence.
- Product documents in `docs/product/` once they exist for the new application.

Inspect the working tree and nearby code/tests before editing. Preserve unrelated work. Prefer the smallest complete vertical slice and existing Rails mechanisms. Create durable coordination artifacts only when the work genuinely needs them; do not create placeholders or ADRs by default.

## Product boundary

Until a derived application commits product boundaries:

- Do not invent a product thesis, domain model, or workflow in this kit.
- Do not add roles, organizations, billing, integrations, or data collection without a demonstrated product requirement.

## Identity and application boundary

Devise provides a confirmed, self-service email-and-password identity with password reset, email-change reconfirmation, rate limiting, and `Current.user`. `ApplicationController` requires authentication by default; public controllers must explicitly opt out. Home, health, and Devise routes remain public.

Keep `User` free of profile fields, roles, memberships, product records, device/session tracking, and self-service deletion. Add authorization policies only with the first protected product resource, and make allowed and denied behavior part of its acceptance evidence.

## Engineering baseline

Keep initial slices inside the Rails monolith. Prefer server-rendered HTML, Turbo for meaningful navigation or interaction improvements, and Stimulus for bounded client behavior. Do not add an architectural layer, SPA framework, API, or dependency without a demonstrated requirement and a check of the capability inventory.

`config/application.rb` is the source of truth for the user-facing application name and default sender. Do not add display-name or sender literals to views or mailers. Production mail is generic SMTP; do not add a provider SDK without a demonstrated requirement.

## Reusable UI surface

Before adding a view pattern, inspect `app/views/shared/` and `/development/ui` in development or test. Reuse the canonical partials for page headers, flash messages, form/field errors, empty states, and recoverable error states. Use the accompanying semantic classes (`content-page`, `page-header`, `form-panel`, `form-field`) rather than creating authentication-specific styling or a component framework. Keep form help and validation errors associated with their controls through `field_accessibility` and `shared/field_error`.

`/development/ui` is a local-only reference page and must remain free of product examples, persisted data, and alternate implementations of those partials. Static `public/400.html`, `404.html`, `422.html`, and `500.html` are self-contained deployment failure pages; do not make them depend on Rails assets or application configuration.

When changing a capability, update `docs/capabilities.md` if its readiness, boundary, or implementation paths change. For sensitive or regulated data, explicitly cover privacy, authorization, security, failure behavior, and recovery.

Run the focused checks for the changed behavior, then the proportional baseline from [verification.md](docs/process/verification.md). Never report an unrun check as passing; classify non-passing checks as introduced, pre-existing, environmental, or intentionally skipped with a reason.
