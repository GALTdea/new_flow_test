# Verification

Run commands from the repository root. Install PostgreSQL locally and ensure its server is reachable before setup or database-backed tests.

## Setup

```sh
bin/setup --skip-server
bin/dev
```

In a derived application, run `bin/rename_app --name "Product Name" --identifier product_name` before `bin/setup` so database and deployment identifiers are created with the product name.

`bin/setup` installs missing gems, prepares the development database, and clears logs and temporary files. Use `bin/setup --reset` only when intentionally recreating that database. `bin/dev` uses the locked `foreman` dependency and never installs a global gem.

## Focused checks

Run the narrowest relevant check before the aggregate:

```sh
bin/rails test test/path/to/focused_test.rb
bin/rails test test/path/to/focused_test.rb:LINE
bin/rails test:system test/system/relevant_journey_test.rb
```

## Baseline

`bin/ci` is the repository-defined local aggregate. It verifies dependencies, prepares only the test database, runs lint and security checks, executes Rails tests, replants test seeds, and runs system tests.

```sh
bin/ci
```

The individual baseline checks are:

```sh
bin/rails test
env RUBOCOP_CACHE_ROOT=tmp/rubocop bin/rubocop
bin/importmap audit
bin/brakeman --no-pager
bin/bundler-audit check --update --database tmp/ruby-advisory-db
bin/rails test:system
```

The gem advisory and import-map audits require network access. GitHub Actions runs Ruby security scans, the import-map audit, lint, Rails tests, and system tests with PostgreSQL 17 through `DATABASE_URL`.

## Evidence by change

| Changed behavior | Minimum evidence |
| --- | --- |
| Shared UI, layout, or static error page | Focused view, request, or static-page test for landmarks, title, feedback, and control associations as applicable. |
| Browser journey | Happy-path system test plus an important failure or empty state. |
| Identity | Request coverage for allowed and failed flows, authentication state, rate limiting where changed, and mail behavior where changed. |
| Authorization or product data | Allowed and denied actor coverage, ownership/non-leakage, data-lifecycle decisions, and recovery behavior. |
| Background job or cache | Focused enqueue/execution or cache behavior evidence; verify the configured adapter when the product starts depending on it. |
| File storage | Attachment persistence, authorization, provider configuration, failure handling, and retention/deletion behavior. |
| Deployment configuration | Configuration validation; if Docker changes, build or otherwise explicitly classify unavailable Docker evidence. |

## Completion rule

Run focused acceptance evidence before the proportional baseline. Never report an unrun check as passing. Classify any non-passing check as introduced, pre-existing, environmental, or intentionally skipped with a reason.
