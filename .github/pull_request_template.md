## What

<!-- What this change does, in a sentence or two. Link the issue it came from. -->

Closes #

## Why

<!-- The problem it solves. Skip only if the "What" already makes it obvious. -->

## Checklist

Tick what applies, delete what does not, and say why for anything left out.

**Code**

- [ ] Follows the existing structure: feature-first, `data`/`domain`/`presentation`, Riverpod for state ([architecture](../docs/architecture.md))
- [ ] Screens stay thin: components live in their own files under `presentation/widgets/<screen_name>/`, no `_buildX()` helpers
- [ ] No inline colors, spacing, radii, durations or text styles: everything comes from `packages/app_ui` tokens
- [ ] No hardcoded user-facing text

**Tests**

- [ ] New logic has tests (repository, use case, ViewModel, widget behaviour)
- [ ] `packages/app_ui` changes have their own tests, including goldens
- [ ] A bug fix has a test that fails without the fix

**Generated and localized**

- [ ] `build_runner` and `gen-l10n` re-run, output committed
- [ ] New strings added to all four ARB files (`en`, `es`, `pt`, `zh`)

**Documentation**

- [ ] Docs updated in all four languages, if the change touched behaviour, structure, tooling or dependencies
- [ ] README test counts and coverage thresholds still accurate

**Gate**

- [ ] `./scripts/verify.sh` passes locally
- [ ] `act pull_request` run, if this touches `.github/workflows/`

## Notes for the reviewer

<!-- Anything deliberately left out, a trade-off taken, or a place worth a closer look. -->
