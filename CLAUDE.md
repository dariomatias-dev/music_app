# CLAUDE.md

Working agreement for this repo. It applies to **every** change: a file under
`lib/src/core/`, a feature slice, a component in `packages/app_ui`, a string, a
script, a workflow, a document. There is no "too small to follow the process"
change.

## Commands

Every command runs through FVM, which pins the SDK version CI uses.

```sh
fvm flutter pub get                                   # dependencies
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter gen-l10n                                  # localizations
fvm flutter run                                       # run on a device
./scripts/verify.sh                                   # the quality gate
```

`./scripts/verify.sh` runs exactly what CI runs (format, analyze, test,
coverage), scoped to the packages with pending changes. Flags: `--all` to check
everything, `--gen` to regenerate first, `--skip-tests` for a quick mid-change
look (never as the final check).

## The loop, every change

1. **Read before writing.** Find the nearest existing example of what you are
   about to add and match it. This repo is highly consistent; consistency wins
   over personal preference.
2. **Change the code**, following the routing table below.
3. **Test it.** See [Tests](#tests). New logic without a test is an incomplete
   change, not a fast one.
4. **Update what the change invalidates.** See [Ripple effects](#ripple-effects).
5. **Regenerate** if you touched anything a generator reads, and commit the
   output. CI fails when regeneration produces a diff.
6. **Run `./scripts/verify.sh`** and get it green. A Stop hook blocks the turn
   while code changes sit unverified.
7. **Report** what changed, what was tested, and anything left out.

## Where code goes

| Change | Location | Also required |
| --- | --- | --- |
| Cross-cutting concern (audio, database, navigation, permissions, services, storage, utils) | `lib/src/core/<area>/` | Test in `test/core/<area>/`. Behind an abstract interface when a test needs to substitute it. |
| App-wide widget that depends on app state | `lib/src/core/widgets/` | Widget test. If it is presentation-only, it belongs in `app_ui` instead. |
| Feature behaviour | `lib/src/features/<feature>/{data,domain,presentation}/` | Respect the layering: `domain` is pure Dart, `data` implements `domain` interfaces, `presentation` holds screens, widgets and ViewModels. |
| Screen | `presentation/screens/`, one file per route | Route in the feature's navigator under `lib/src/core/navigation/navigators/`. Thin: composes widgets, owns callbacks, renders nothing inline. |
| Component used by one screen | `presentation/widgets/<screen_name>/<component>.dart` | One public class per file. No private widget classes trailing a screen, no `_buildX()` helpers. |
| Component shared within a feature | `presentation/widgets/<name>.dart` | |
| Design-system component, token, or theme value | `packages/app_ui/lib/src/<area>/` | Export it from `packages/app_ui/lib/app_ui.dart`, and add a test plus a golden under `packages/app_ui/test/`. |
| Database schema | `lib/src/core/database/tables/`, DAO in `daos/` | A migration that preserves user data, and a migration test. Never edit an existing table without one. |
| User-facing string | `lib/l10n/app_en.arb` **and** `app_es.arb`, `app_pt.arb`, `app_zh.arb` | All four, in the same change. Then `fvm flutter gen-l10n`. |

A feature depends on another feature's `domain` only, never its `data` or
`presentation`.

## Non-negotiables

- **No inline styling.** Colors, spacing, radii, durations, curves, text styles
  and sizes come from `app_ui` tokens (`AppSpacing`, `AppSizes`, `AppRadius`,
  `AppDurations`, `AppCurves`, `context.colors`). A hardcoded value is a bug.
- **No hardcoded user-facing text.** It goes through the ARB files.
- **No new pattern without discussion.** Riverpod for state, go_router for
  navigation, drift for persistence, freezed for entities. If the change seems
  to need something else, say so and stop rather than introducing it.
- **`packages/app_ui` never imports the app.** It is a standalone package with
  no knowledge of features, repositories or providers.
- **Never run `git commit` unless the user asks in that turn.** Staging and
  committing are theirs to trigger.

## Tests

Anything with logic gets a test, in the mirrored path under `test/` (or
`packages/app_ui/test/`).

| What | Test |
| --- | --- |
| Repository, use case, mapper, service, util | Unit test against a fake, using the fakes in `test/helpers/`. Add a fake there if none fits. |
| ViewModel | Unit test driving the notifier through its states, with provider overrides. |
| Screen or widget | Widget test with `pumpApp` from `test/helpers/pump_app.dart`. |
| `app_ui` component | Widget test plus a golden via `test/helpers/pump_golden.dart`. |
| End-to-end flow across features | `integration_test/`, using the harness in `integration_test/helpers/`. Assert on the outcome, never on a toast: CI runs the emulator with animations disabled, so a wait on a transient message passes on a device and times out there. |

Coverage thresholds are enforced, not advisory: 97% for the app, 98% for
`packages/app_ui`. Generated files, `lib/l10n/` and drift table declarations are
excluded from the count by `scripts/check_coverage.sh`.

## Ripple effects

Ask these on every change, and act on the ones that apply.

- **Did a user-visible capability change?** Update `README.md` and its `.es`,
  `.pt-BR` and `.zh` versions. All four, same change.
- **Did the structure, a layer boundary or a convention change?** Update
  `docs/architecture.md` in all four languages.
- **Did the workflow, the checks or the tooling change?** Update
  `docs/contributing.md` in all four languages.
- **Did the test count or a coverage threshold change?** The README's Testing
  section quotes both.
- **Did a script gain, lose or change behaviour?** The README's Scripts table.
- **Did a dependency get added, removed or pinned?** `pubspec.yaml` comments
  explain every pin, and `docs/dependencies.md` (four languages) documents the
  deliberate ones.
- **Did a CI job change?** `docs/contributing.md` documents the jobs, and
  `act pull_request` runs them locally before pushing.

Documentation in this repo ships in English, Spanish, Portuguese (BR) and
Chinese. A doc change in one language and not the other three is a broken
change.

## Style

- `very_good_analysis` lints, with the exceptions in `analysis_options.yaml`.
- Comments explain **why**, never what. Most code needs none; a deliberate
  deviation needs one.
- Conventional Commits for messages: `feat:`, `fix:`, `docs:`, `refactor:`,
  `test:`, `ci:`, `chore:`, with a short imperative subject.
- Prefer `const`, immutable data, and composition over inheritance.

## Reference

- [`docs/architecture.md`](docs/architecture.md): layout, layering, conventions.
- [`docs/contributing.md`](docs/contributing.md): setup, CI, dependency policy.
- [`docs/dependencies.md`](docs/dependencies.md): why packages are pinned.
