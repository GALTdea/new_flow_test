# System overview

This document describes the current application shape and boundaries. See [capabilities](../capabilities.md) for readiness and implementation detail.

## Application shape

The application is a single server-rendered Rails monolith. `.ruby-version` and `Gemfile.lock` are the sources of truth for the exact Ruby and Rails versions.

```text
browser
  ↕ HTTPS when deployed
Rails application
  ↕
PostgreSQL primary database
```

Development and test use the primary database. Production configuration also defines separate PostgreSQL connections for Solid Cache, Solid Queue, and Solid Cable. Their schemas and adapters are present, but no starter behavior currently depends on them.

The only application-domain table is `users`. It stores Devise identity data: email, password digest, confirmation, reset, and remember-me metadata. No product data, profile fields, roles, memberships, or device/session registry exists.

## Boundaries

- Browser behavior is Rails HTML with Turbo, Stimulus, import maps, Propshaft, and Tailwind CSS.
- Devise provides the identity boundary. Controllers require authentication by default; home, `/up`, and Devise routes are explicitly public.
- Shared UI is implemented with Rails partials and Tailwind. `/development/ui` is a local-only reference page; public 400, 404, 422, and 500 pages are self-contained.
- Action Mailer is provider-neutral SMTP in production and uses Letter Opener in development and in-memory delivery in test.
- Active Storage services are configured, but no attachment tables, provider, or image variants exist. Attachments are deferred to a product requirement.
- Docker and Kamal files are deployment scaffolding only. A production topology, backup policy, rollback procedure, storage policy, and deployment authority remain product decisions.

## Data lifecycle

Account identity is the only persisted application data. Before collecting product or sensitive data, define ownership, authorization, retention, deletion, logging, consent, and recovery boundaries. Account deletion is intentionally not a generic identity operation; design it with the first product data lifecycle.

## Operating principle

Keep early product slices inside this monolith. Add a separate runtime, external service, queue workflow, API, or dependency only when an exercised requirement justifies it.
