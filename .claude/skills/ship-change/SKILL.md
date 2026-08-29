---
name: ship-change
description: The end-to-end recipe for landing any change in this repo, from a core service to an app_ui component to a single localized string. Use when adding, changing or removing anything under lib/, packages/, integration_test/, scripts/ or docs/, and whenever unsure which files a change obliges you to touch. Covers the per-change-type file lists, the tests each type requires, the documentation each type invalidates, and the gate that has to pass before the work is done.
---

# Shipping a change

`CLAUDE.md` holds the working agreement. This skill holds the recipes: for a
given kind of change, exactly which files it obliges you to touch.

Pick the matching recipe, do every line in it, then run the closing gate at the
bottom. A step that genuinely does not apply gets skipped out loud, in the final
report, not silently.

## Before any recipe

Find the nearest existing example and read it. `lib/src/core/services/` has
seven services built the same way; `packages/app_ui/lib/src/components/` has
dozens of components built the same way. Match the one you find. If nothing
comparable exists, that is the signal to ask rather than to invent.

## Recipe: core service, util or storage abstraction

Cross-cutting code, used by more than one feature.

1. Abstract interface plus implementation in
   `lib/src/core/<area>/<name>/<name>.dart` (a folder per service when the
   implementation splits into more than one file, matching the neighbours).
2. Riverpod provider for it, wherever the neighbouring services expose theirs.
3. Unit test in `test/core/<area>/`, covering the branches, not the happy path
   alone.
4. A fake in `test/helpers/fake_<name>.dart` if any other test will need to
   substitute it.
5. `docs/architecture.md` (four languages) only if the change adds a new
   directory under `core/` or changes what a layer is allowed to do.

## Recipe: feature behaviour

1. `domain/`: entity (freezed) and/or abstract repository interface. Pure Dart:
   no Flutter, no Riverpod, no drift. A use case class with a single `call()`
   when there is real branching logic.
2. `data/`: the implementation against a drift DAO, key-value storage or a
   plugin, plus the mappers between row types and domain entities.
3. `data/providers/<feature>_data_providers.dart`: wire the implementation to
   the interface.
4. `presentation/view_models/`: a `Notifier`/`AsyncNotifier` exposed through a
   generated provider.
5. `presentation/screens/` and `presentation/widgets/`: the UI, thin screen,
   one public component class per file.
6. Tests mirroring every one of the above under `test/features/<feature>/`.
7. Regenerate: `fvm dart run build_runner build --delete-conflicting-outputs`.

A feature imports another feature's `domain` only.

## Recipe: new screen or route

1. Screen file under `presentation/screens/`, one per route.
2. Route class in the feature's navigator under
   `lib/src/core/navigation/navigators/`, following the typed
   `go_router_builder` pattern already there.
3. Components under `presentation/widgets/<screen_name>/`.
4. Every string through the ARB files, all four languages.
5. Regenerate (`build_runner` for the router, `gen-l10n` for the strings).
6. Widget test for the screen with `pumpApp`, plus a golden if the screen is a
   primary destination (see the goldens already under
   `test/features/*/presentation/screens/goldens/`).

## Recipe: `packages/app_ui` component, token or theme value

The design system is a standalone package: it must not know the app exists.

1. Implementation under `packages/app_ui/lib/src/<area>/`.
2. Export from `packages/app_ui/lib/app_ui.dart`, or from the area barrel that
   file already exports (`buttons.dart`, `cards.dart`, ...).
3. Widget test under `packages/app_ui/test/<area>/`, plus a golden through
   `test/helpers/pump_golden.dart`, written into the neighbouring `goldens/`.
4. Everything visual comes from tokens; a component that hardcodes a value is
   the bug this package exists to prevent.
5. Gate with the 98% threshold: `./scripts/verify.sh` picks it up automatically
   when `packages/app_ui` has changes.
6. `docs/architecture.md` (four languages) if the change adds a component
   category rather than a component.

## Recipe: database schema

The one change type that can destroy user data. Treat it accordingly.

1. Table under `lib/src/core/database/tables/`, DAO under `daos/`.
2. Bump the schema version and add a migration step that **preserves existing
   rows**. Never edit a shipped table without one.
3. Migration test: seed the old schema, migrate, assert the data survived.
4. Regenerate drift output and commit it.
5. Index anything the app queries by.

## Recipe: user-facing string

1. Add the key to `lib/l10n/app_en.arb` with a `@key` description.
2. Add the same key to `app_es.arb`, `app_pt.arb` and `app_zh.arb`, translated.
   Four files, one change, no exceptions.
3. `fvm flutter gen-l10n`, commit the generated `app_localizations*.dart`.
4. Read it through `AppLocalizations.of(context)!`, the pattern every screen
   already uses, never as a literal.

## Recipe: bug fix

1. Write the failing test first, at the layer where the bug lives.
2. Fix it.
3. Confirm the test now passes and nothing else broke.
4. Ask whether the same mistake exists elsewhere, and say what you found.

## Recipe: dependency change

1. Edit `pubspec.yaml`, keeping the purpose grouping (dependencies are grouped
   by role, not alphabetically; `sort_pub_dependencies` is off for that reason).
2. A pin below the latest version needs a comment saying why, right above it.
3. `docs/dependencies.md` (four languages) documents the deliberate pins and
   which Dependabot PRs to close rather than merge.
4. `README.md` (four languages) lists the notable packages in Built With.

## Recipe: script, workflow or tooling change

1. The change itself.
2. `docs/contributing.md` (four languages) documents the checks and the jobs.
3. The README's Scripts table lists every script in `scripts/`.
4. Workflow changes: run `act pull_request` before pushing, per
   `docs/contributing.md`.

## Recipe: documentation only

Every document exists in four languages: `<name>.md` (English),
`<name>.es.md`, `<name>.pt-BR.md`, `<name>.zh.md`. Change one, change all four,
keeping the language switcher header intact. The gate does not run for
docs-only changes, so re-read the translations instead.

## The closing gate

Always, before reporting the work done:

```sh
./scripts/verify.sh          # add --gen if a generator's input changed
```

It runs format, analyze, test and the coverage threshold for each package with
pending changes, which is what CI will run. Green means CI has no new reason to
fail. Red means the change is not finished.

Then report: what changed, what was tested, what was intentionally skipped.
Do not commit unless the user asked for a commit in that turn.
