# Starter App

Reusable Rails 8 application foundation for beginning product work from a known-good server-rendered baseline.

## What is included

- Ruby 3.4.10, Rails 8.1, PostgreSQL
- Hotwire, import maps, Propshaft, and Tailwind CSS
- Accessible application shell: skip link, landmarks, semantic flash messages, identity-only account links, and canonical Rails partials for page headers, form errors, field errors, empty states, and error states
- Devise identity-only accounts: sign up, confirmation, sign in/out, password reset, and email/password settings
- Minitest, home and authentication system journeys, RuboCop, Brakeman, bundler-audit, and GitHub Actions
- Generated Kamal and Docker scaffolding with placeholder hosts

## What is not included

- Authorization, roles, profiles, OAuth, per-device session tracking, self-service account deletion, or attaching product records to `User`
- A product domain model or workflow
- An approved production or data-lifecycle plan

## Starter App v1 boundary

This is the intended v1 scope. See [application capabilities](docs/capabilities.md) for the current readiness of each item.

**Must have:** the Rails/PostgreSQL/Hotwire foundation; accessible shell and core form primitives;
confirmed self-service Devise identity with `Current.user`; mail, jobs, health check, tests, security tooling,
and concise developer/agent guidance.

**Should have:** privacy-conscious logging guidance, Solid Cache configuration, and a verified fresh-copy rename exercise.

**Later:** authorization policies, file attachments (including image variants), pagination, monitoring, device management,
account deletion, OAuth/MFA, and application-template automation.

The `User` model is an email-and-password identity only. It has no profile fields, roles, memberships, device
registry, or product records. Future products must explicitly decide whether public registration remains suitable
before launch, and must design deletion alongside their data lifecycle.

## Reusable UI surface

See [application capabilities](docs/capabilities.md) for the current readiness and boundary of each inherited facility. Use the shared partials in `app/views/shared/` and the semantic classes in `app/assets/tailwind/application.css` before creating a new application pattern. In development and test, `/development/ui` renders those canonical partials with representative states. The route is never available in production.

## Setup

```sh
bin/setup --skip-server
bin/dev
```

## Verification

```sh
bin/rails test
bin/rails test:system
env RUBOCOP_CACHE_ROOT=tmp/rubocop bin/rubocop
bin/importmap audit
bin/brakeman --no-pager
bin/bundler-audit check --update --database tmp/ruby-advisory-db
bin/ci
```

See [docs/process/verification.md](docs/process/verification.md).

## Production mail contract

The starter provides SMTP configuration, not a mail vendor integration. Production boot requires:

| Variable | Purpose |
| --- | --- |
| `MAILER_HOST` | Public application host used in confirmation and reset links. |
| `MAILER_FROM` | Sender address, including the display name if desired. |
| `SMTP_ADDRESS` | SMTP server host. |
| `SMTP_PORT` | SMTP port; defaults to `587`. |
| `SMTP_DOMAIN` | SMTP HELO domain; defaults to `MAILER_HOST`. |
| `SMTP_USERNAME`, `SMTP_PASSWORD` | SMTP credentials when the service requires them. |
| `SMTP_AUTHENTICATION` | Authentication mode; defaults to `plain` when `SMTP_USERNAME` is set. |
| `SMTP_ENABLE_STARTTLS_AUTO` | Set to `false` only when the SMTP service requires it; defaults to `true`. |

`MAILER_PROTOCOL` defaults to `https`. Development uses Letter Opener instead of an SMTP service, and tests use Rails' in-memory delivery method.

## Create a product from this starter

1. Copy this repository into a new repository.
2. Preview the operational rename, then apply it before creating databases:

   ```sh
   bin/rename_app --name "Acme Portal" --identifier acme_portal --dry-run
   bin/rename_app --name "Acme Portal" --identifier acme_portal
   ```

   The command derives `AcmePortal` as the Ruby module; pass `--module AcmePortal` to override that derivation. It changes only `config/application.rb`, `config/database.yml`, `config/deploy.yml`, and Docker examples.
3. Generate new credentials for the new repository. Do not reuse this kit's master key in a public or shared copy.
4. Replace this README's starter-specific introduction, v1 boundary, and handoff checklist with the product README.
5. Replace the starter identity and product-boundary sections of `AGENTS.md`, then add product context under `docs/product/` before implementing domain behavior.
6. Retain and update `docs/capabilities.md`, `docs/architecture/`, and `docs/process/`; they describe inherited infrastructure.
7. Run `bin/setup --skip-server`, configure the production mail contract before deploying, and run `bin/ci`.
8. Remove remaining starter-only history and this handoff checklist. Keep the shell, CI, and verification habit while adding the first vertical slice.
