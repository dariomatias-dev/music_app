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
- **Keep screens thin**: a screen composes widgets and wires providers. Components go in their own file under `presentation/widgets/<screen_name>/` — not as private classes trailing the screen file, and not as `_buildX()` helper methods. See [Widget organization](architecture.md#widget-organization).
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

Every push and pull request runs [`.github/workflows/ci.yaml`](../.github/workflows/ci.yaml), in three jobs:

| Job | What it does |
| --- | --- |
| `music_app` | Installs dependencies, regenerates code and localizations, then **fails if that regeneration produced a diff** — generated files must be committed and up to date. Then formatting, analysis, tests, and the 97% coverage gate. |
| `Build APK` | Runs after `music_app` passes, and builds a release APK, uploaded as a workflow artifact kept for 14 days. |
| `packages/app_ui` | Formatting, analysis, tests, and the 98% coverage gate for the design-system package, independently of the app. |

Pushing a `v*.*.*` tag runs [`.github/workflows/release.yml`](../.github/workflows/release.yml) instead: the same checks, then a release APK published to a GitHub release with generated notes. Note that the release build is signed with the **debug keystore** on purpose — this app has no production signing config.

### Running the workflows locally

[`act`](https://github.com/nektos/act) runs the workflows in Docker, which is worth doing before pushing a change to anything under `.github/workflows/`. The repo's `.actrc` already pins the runner image, so no flags are needed:

```sh
act -l                                # list every job, with its id and stage
act pull_request                      # everything CI would run on a PR
act pull_request -j app               # one job, by its id
act pull_request -j app --dryrun      # print the steps without running them
```

`-j` takes the job **id** (`app`, `build_apk`, `app_ui`, `release`), not the display name in the table above; `act -l` prints both. The first real run pulls a multi-gigabyte runner image, and `act` approximates GitHub's runners rather than reproducing them exactly — a green `act` run is a good signal, not a guarantee.

## Dependency updates

Dependabot is configured in [`.github/dependabot.yml`](../.github/dependabot.yml) and opens weekly pull requests for four ecosystems: pub (the app), pub (`packages/app_ui`), Gradle (`android/`), and GitHub Actions.

Those pull requests go through the same CI as any other. Before approving one, check [`dependencies.md`](dependencies.md): a few packages are held below their latest version deliberately, and a Dependabot PR bumping one of those chains should be closed rather than merged.

## Code of Conduct

Participation in this project is governed by the [Code of Conduct](code_of_conduct.md).
