#!/usr/bin/env bash
#
# Runs the same quality gate CI enforces, on the packages a change touched.
#
# The steps mirror .github/workflows/ci.yaml exactly, so a green run here means
# CI has no new reason to fail: generated output, formatting, analysis, tests,
# and the coverage threshold, for the app and for packages/app_ui
# independently.
#
# Scope is derived from the working tree: only the packages with pending
# changes are checked. Pass --all to check everything regardless.
#
# On success the current workspace hash is recorded in .dart_tool/verify_stamp.
# The Stop hook reads it to tell whether the tree still matches a passing run.
#
# Code generation runs on every invocation, and the run fails when it changed
# anything: CI regenerates from a clean checkout and rejects the build when the
# result differs from what was committed, which is a failure no other local
# check can see coming.
#
# Usage: scripts/verify.sh [--all] [--skip-tests]
#
#   --all         Check the app and packages/app_ui, ignoring what changed.
#   --skip-tests  Generation, formatting and analysis only. For a quick
#                 mid-change check, never as the final gate.

set -euo pipefail

export LC_ALL=C

readonly root="$(git rev-parse --show-toplevel)"
cd "$root"

check_all=false
skip_tests=false

for arg in "$@"; do
  case "$arg" in
    --all) check_all=true ;;
    --skip-tests) skip_tests=true ;;
    -h|--help)
      sed -n '2,28p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "verify.sh: unknown option '$arg'" >&2
      exit 2
      ;;
  esac
done

if command -v fvm >/dev/null 2>&1 && [[ -f .fvmrc ]]; then
  flutter=(fvm flutter)
  dart=(fvm dart)
else
  flutter=(flutter)
  dart=(dart)
fi

step() {
  printf '\n\033[1m==> %s\033[0m\n' "$1"
}

# Fingerprints every generated file, tracked or not, so a regeneration that
# changes one can be told apart from one that confirms them all.
generated_fingerprint() {
  git ls-files -co --exclude-standard \
    -- '*.g.dart' '*.freezed.dart' 'lib/l10n/app_localizations*.dart' \
    | sort \
    | xargs -r sha1sum \
    | sha1sum
}

step "generate code and localizations"
before_generation="$(generated_fingerprint)"
"${dart[@]}" run build_runner build --delete-conflicting-outputs
"${flutter[@]}" gen-l10n

if [[ "$(generated_fingerprint)" != "$before_generation" ]]; then
  cat >&2 <<'MESSAGE'

Generated output was out of date and has just been refreshed. Review the
changes and commit them: CI regenerates from a clean checkout and fails when
the result differs from what the branch carries.
MESSAGE
  git status --porcelain -- '*.g.dart' '*.freezed.dart' \
    'lib/l10n/app_localizations*.dart' >&2
  exit 1
fi

changed_paths() {
  git status --porcelain -uall -- \
    lib test integration_test test_driver packages \
    pubspec.yaml analysis_options.yaml l10n.yaml \
    | sed -e 's/^...//' -e 's/.* -> //' -e 's/^"//' -e 's/"$//'
}

check_app=false
check_app_ui=false

if "$check_all"; then
  check_app=true
  check_app_ui=true
else
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    case "$path" in
      packages/app_ui/*) check_app_ui=true ;;
      packages/*) ;;
      *) check_app=true ;;
    esac
  done < <(changed_paths)
fi

if ! "$check_app" && ! "$check_app_ui"; then
  echo "Nothing to verify: no pending changes under lib, test, packages, or the root manifests."
  echo "Pass --all to run the full gate anyway."
  exit 0
fi

# Runs formatting, analysis, tests and the coverage gate for one package.
#
#   $1  directory to run in, relative to the repo root
#   $2  minimum line coverage percentage
#   $3  human-readable name, for the step headings
verify_package() {
  local dir="$1" minimum="$2" name="$3"

  step "$name: format"
  (cd "$dir" && "${dart[@]}" format --output=none --set-exit-if-changed lib test)

  step "$name: analyze"
  (cd "$dir" && "${flutter[@]}" analyze)

  if "$skip_tests"; then
    step "$name: tests skipped (--skip-tests)"
    return
  fi

  step "$name: test"
  (cd "$dir" && "${flutter[@]}" test --coverage)

  step "$name: coverage (minimum ${minimum}%)"
  "$root/scripts/check_coverage.sh" "$dir/coverage/lcov.info" "$minimum"
}

if "$check_app_ui"; then
  verify_package packages/app_ui 98 "packages/app_ui"
fi

if "$check_app"; then
  step "music_app: localizations"
  "$root/scripts/check_l10n.sh"

  verify_package . 97 "music_app"
fi

if "$skip_tests"; then
  printf '\n\033[1mPartial run: tests were skipped, no stamp recorded.\033[0m\n'
  exit 0
fi

mkdir -p .dart_tool
"$root/scripts/workspace_hash.sh" > .dart_tool/verify_stamp

printf '\n\033[1;32mAll checks passed.\033[0m\n'
