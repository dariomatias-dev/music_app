# Contributing

<p align="center">
<strong>English</strong> · <a href="contributing.es.md">Español</a> · <a href="contributing.pt-BR.md">Português (BR)</a> · <a href="contributing.zh.md">中文</a>
</p>

Thanks for considering a contribution. This document covers setup, conventions, and what a pull request needs before it's ready for review. For how the codebase is organized, see [`architecture.md`](architecture.md).

## Setup

The project pins its Flutter SDK version via [FVM](https://fvm.app/), so every command below uses `fvm flutter` rather than a bare `flutter` install.

```sh
git clone https://github.com/dariomatias-dev/music_app.git
cd music_app
fvm install
fvm flutter pub get
```

Generated code (freezed, json_serializable, drift, riverpod_generator, go_router_builder) and localizations aren't committed pre-built for every change — regenerate them after pulling or editing anything they depend on:

```sh
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter gen-l10n
```

Run the app on a connected device or emulator with `fvm flutter run`.

## Before opening a pull request

- **Open an issue first** to discuss the change, unless it's a small, obvious fix.
- **Follow the existing structure**: feature-first, `data`/`domain`/`presentation` layers, Riverpod for state, no new patterns introduced without discussion. See [`architecture.md`](architecture.md).
- **Match the design system**: no inline colors, spacing, or durations — use the tokens and components from `packages/app_ui`.
- **Add tests** for anything with logic: a repository method, a use case, a `ViewModel`, a widget's behavior. `packages/app_ui` is a separate package with its own test suite; changes there need their own tests too.
- **Every doc, string, and localized asset ships in every supported language** (English, Spanish, Portuguese, Chinese) — the `lib/l10n/*.arb` files, and any documentation in `docs/`.
- **Run the full check locally** before pushing:

  ```sh
  fvm flutter analyze
  fvm dart format --output=none --set-exit-if-changed lib test
  fvm flutter test --coverage
  ./scripts/check_coverage.sh coverage/lcov.info 97
  ```

  (Run the same four commands inside `packages/app_ui/` for changes there; its coverage threshold is 98.)

- **Commit messages** follow [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `ci:`, etc., with a short imperative subject. Look at `git log` for examples already in the repo.

## What CI checks

Every push and pull request runs the same checks described above, plus a check that generated files (build_runner output, localizations) are committed and up to date, and a release APK build. See `.github/workflows/ci.yml` for the exact steps.

## Code of Conduct

Participation in this project is governed by the [Code of Conduct](code_of_conduct.md).
