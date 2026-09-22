# Application capabilities

This inventory describes infrastructure currently present in the application. It is portable: retain it in a derived product and update it whenever a capability changes.

## Statuses

- **Ready** — configured and exercised by automated verification.
- **Configured** — infrastructure exists, but no starter behavior exercises it.
- **Scaffold only** — placeholder that needs product or deployment decisions.
- **Deferred** — intentionally unfinished until a product requirement exists.
- **Not included** — deliberately outside the current boundary.

## Inventory

| Capability | Status | Key paths | Implementation and boundary |
| --- | --- | --- | --- |
| Rails foundation | Ready | `.ruby-version`, `Gemfile`, `config/database.yml` | Ruby/Rails versions are locked by `.ruby-version` and `Gemfile.lock`; PostgreSQL, server-rendered Rails, Turbo, Stimulus, import maps, Propshaft, and Tailwind are the baseline. |
| Derived-app rename | Ready | `bin/rename_app`, `test/scripts/rename_app_test.rb` | One-time initializer for the module, display name, database identifiers, Kamal identifiers, and Docker examples. It supports `--dry-run` and does not replace product documentation. |
| Application shell and UI | Ready | `app/views/shared/`, `app/assets/tailwind/application.css`, `test/controllers/development/` | Shared partials provide page headers, flash messages, validation feedback, empty states, and recoverable error states. `/development/ui` renders canonical partials only in development and test. |
| Static failure pages | Ready | `public/{400,404,422,500}.html`, `test/public_error_pages_test.rb` | Failure pages are self-contained and tested without Rails assets. |
| Identity | Ready | `app/models/user.rb`, `app/controllers/users/`, `test/controllers/users/` | Devise provides confirmed email/password registration, sign in/out, password reset, email-change reconfirmation, rate limits, and `Current.user`. `User` is identity-only. |
| Controller authentication | Ready | `app/controllers/application_controller.rb`, `app/controllers/concerns/authentication.rb` | `ApplicationController` requires authentication by default; public controllers explicitly opt out. |
| Mail | Ready | `config/environments/`, `app/mailers/`, `test/controllers/users/passwords_controller_test.rb` | Development uses Letter Opener, test uses in-memory delivery, and production requires documented provider-neutral SMTP variables. |
| Health check | Ready | `config/routes.rb` | Rails exposes `/up` for application liveness. It is not a database or dependency readiness probe. |
| Verification and security tooling | Ready | `bin/ci`, `.github/workflows/ci.yml`, `docs/process/verification.md` | Minitest, Capybara/Selenium, RuboCop, Brakeman, bundler-audit, import-map audit, GitHub Actions, and `bin/ci` are configured. |
| Logging privacy baseline | Ready | `config/initializers/filter_parameter_logging.rb`, `config/environments/production.rb` | Request IDs and filtered sensitive parameters are configured. There is no structured event schema, external monitoring, or error-monitoring service. |
| Solid Queue | Configured | `config/queue.yml`, `config/puma.rb`, `db/queue_schema.rb` | Production uses Solid Queue with a separate schema and optional Puma plugin. No starter job exercises the queue. |
| Solid Cache | Configured | `config/cache.yml`, `db/cache_schema.rb` | Production uses Solid Cache with a separate schema. No starter caching behavior depends on it. |
| Solid Cable | Configured | `config/cable.yml`, `db/cable_schema.rb` | Production uses Solid Cable with a separate schema. No channel behavior exists. |
| Active Storage | Deferred | `config/storage.yml`, `config/application.rb` | Local and test services are configured, but attachment tables, a production provider, and image variants are absent. |
| Docker and Kamal | Scaffold only | `Dockerfile`, `config/deploy.yml` | Container build and deployment files exist, but hosts, registry, database topology, storage/backup policy, rollback procedure, and deployment authority are not established. |
| Development seed users | Not included | `db/seeds.rb`, `test/fixtures/users.yml` | Seeds intentionally create no users; tests use fixtures rather than development seeds. |
| Authorization, pagination, monitoring | Not included | `Gemfile`, `app/policies/` absent | No Pundit, pagination library, monitoring vendor, or logging platform is installed. Add one only for an exercised product need. |
| Product capabilities | Not included | `app/models/`, `docs/product/` | Roles, organizations, invitations, billing, subscriptions, OAuth, APIs, multi-tenancy, analytics, chat, and AI integrations remain product decisions. |

See the [system overview](architecture/system-overview.md) for application shape and the [verification guide](process/verification.md) for relevant evidence. Do not add an overlapping inventory elsewhere.
