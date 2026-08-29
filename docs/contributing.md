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
  ./scripts/verify.sh
  ```

  It runs what CI runs, scoped to the packages you changed: formatting, analysis, tests, and the coverage threshold (97% for the app, 98% for `packages/app_ui`). Add `--gen` when the change touched anything `build_runner` or `gen-l10n` reads, `--all` to check both packages regardless of what changed, or `--skip-tests` for a quick formatting and analysis pass mid-change.

  The same checks by hand, run inside the package being changed:

  ```sh
  fvm flutter analyze
  fvm dart format --output=none --set-exit-if-changed lib test
  fvm flutter test --coverage
  ./scripts/check_coverage.sh coverage/lcov.info 97
  ```

- **Commit messages** follow [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `ci:`, etc., with a short imperative subject. Look at `git log` for examples already in the repo.

## What CI checks

Every push and pull request runs [`.github/workflows/ci.yaml`](../.github/workflows/ci.yaml), in four jobs:

| Job | What it does |
| --- | --- |
| `music_app` | Installs dependencies, regenerates code and localizations, then **fails if that regeneration produced a diff** — generated files must be committed and up to date. Then formatting, analysis, tests, and the 97% coverage gate, and uploads the report to Codecov under the `app` flag. |
| `Build APK` | Runs after `music_app` passes, and builds a release APK, uploaded as a workflow artifact kept for 14 days. |
| `packages/app_ui` | Formatting, analysis, tests, and the 98% coverage gate for the design-system package, independently of the app, uploaded to Codecov under the `app_ui` flag. |
| `Integration tests` | Runs after `music_app` passes, boots an Android emulator and runs every `integration_test/` suite on it in one session, since booting is by far the slowest step. These need a device: the flows read through drift's stream queries, which never emit under the fake async a plain `flutter test` run uses. The job enables KVM first, without which the emulator falls back to software rendering and times out. It also builds a debug APK **before** booting the emulator: a cold Android build downloads an extra SDK platform and CMake and compiles native sources, which on its own outruns the 8-minute bound each suite runs under. Between the two, the job gets a 40-minute budget. |

Pushing a `v*.*.*` tag runs [`.github/workflows/release.yml`](../.github/workflows/release.yml) instead: the same checks, then a release APK published to a GitHub release with generated notes. Note that the release build is signed with the **debug keystore** on purpose — this app has no production signing config.

### Coverage reports

[`scripts/check_coverage.sh`](../scripts/check_coverage.sh) is what fails a build; [Codecov](https://codecov.io/gh/dariomatias-dev/music_app) is what makes the number readable. Each package uploads its `lcov.info` under its own flag, so the two thresholds are tracked separately, and a pull request gets a comment with the per-flag delta and inline annotations on uncovered new lines. [`codecov.yml`](../codecov.yml) holds the targets and repeats the script's exclusions: generated sources, `lib/l10n/`, and the drift table declarations.

Uploads authenticate with a `CODECOV_TOKEN` repository secret. Pull requests from forks cannot read it and fall back to Codecov's tokenless upload, so the step is deliberately set to `fail_ci_if_error: false` — a failed upload is a missing report, never a failed build.

For the same thing locally, without an account, render the `lcov` file to HTML:

```sh
fvm flutter test --coverage
genhtml coverage/lcov.info -o coverage/html   # apt install lcov
xdg-open coverage/html/index.html
```

### Running the workflows locally

[`act`](https://github.com/nektos/act) runs the workflows in Docker, which is worth doing before pushing a change to anything under `.github/workflows/`. The repo's `.actrc` already pins the runner image, so no flags are needed:

```sh
act -l                                # list every job, with its id and stage
act pull_request                      # everything CI would run on a PR
act pull_request -j app               # one job, by its id
act pull_request -j app --dryrun      # print the steps without running them
```

`-j` takes the job **id** (`app`, `build_apk`, `integration`, `app_ui`, `release`), not the display name in the table above; `act -l` prints both. The first real run pulls a multi-gigabyte runner image, and `act` approximates GitHub's runners rather than reproducing them exactly — a green `act` run is a good signal, not a guarantee.

## Working with an AI agent

The repo carries its own agent configuration, so an assistant follows the same process a contributor does instead of improvising one per prompt:

- [`CLAUDE.md`](../CLAUDE.md) is the working agreement, read on every turn: where code belongs, what each kind of change obliges you to test, and which documents a change invalidates.
- [`.claude/skills/ship-change/SKILL.md`](../.claude/skills/ship-change/SKILL.md) holds the per-change recipes: a core service, a feature slice, an `app_ui` component, a schema change with its migration, a localized string, a dependency bump.
- [`.claude/settings.json`](../.claude/settings.json) wires two hooks. Every Dart file written is formatted immediately, and a `Stop` hook refuses to end a turn while code changes have not passed `./scripts/verify.sh`.
- [`.github/pull_request_template.md`](../.github/pull_request_template.md) puts the same checklist in front of the reviewer.

None of it replaces CI, which stays the authority. It exists so the local pass matches what CI will say. Changing the agreement, the recipes or the hooks is a normal change: update this section along with it.

## Dependency updates

Dependabot is configured in [`.github/dependabot.yml`](../.github/dependabot.yml) and opens weekly pull requests for four ecosystems: pub (the app), pub (`packages/app_ui`), Gradle (`android/`), and GitHub Actions.

Those pull requests go through the same CI as any other. Before approving one, check [`dependencies.md`](dependencies.md): a few packages are held below their latest version deliberately, and a Dependabot PR bumping one of those chains should be closed rather than merged.

## Code of Conduct

Participation in this project is governed by the [Code of Conduct](code_of_conduct.md).
