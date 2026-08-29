#!/usr/bin/env bash
#
# Runs the same quality gate CI enforces, on the packages a change touched.
#
# The steps mirror .github/workflows/ci.yaml exactly, so a green run here means
# CI has no new reason to fail: formatting, analysis, tests, and the coverage
# threshold, for the app and for packages/app_ui independently.
#
# Scope is derived from the working tree: only the packages with pending
# changes are checked. Pass --all to check everything regardless.
#
# On success the current workspace hash is recorded in .dart_tool/verify_stamp.
# The Stop hook reads it to tell whether the tree still matches a passing run.
#
# Usage: scripts/verify.sh [--all] [--gen] [--skip-tests]
#
#   --all         Check the app and packages/app_ui, ignoring what changed.
#   --gen         Run build_runner and gen-l10n first. Needed after editing
#                 anything the generators read: drift tables, freezed or
#                 json_serializable models, riverpod providers, go_router
#                 routes, or lib/l10n/*.arb.
#   --skip-tests  Formatting and analysis only. For a quick mid-change check,
#                 never as the final gate.

set -euo pipefail

export LC_ALL=C

readonly root="$(git rev-parse --show-toplevel)"
cd "$root"

check_all=false
run_gen=false
skip_tests=false

for arg in "$@"; do
  case "$arg" in
    --all) check_all=true ;;
    --gen) run_gen=true ;;
    --skip-tests) skip_tests=true ;;
    -h|--help)
      sed -n '2,25p' "$0" | sed 's/^# \{0,1\}//'
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

step() {
  printf '\n\033[1m==> %s\033[0m\n' "$1"
}

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

if "$run_gen"; then
  step "generate code"
  "${dart[@]}" run build_runner build --delete-conflicting-outputs

  step "generate localizations"
  "${flutter[@]}" gen-l10n
fi

if "$check_app_ui"; then
  verify_package packages/app_ui 98 "packages/app_ui"
fi

if "$check_app"; then
  verify_package . 97 "music_app"
fi

if "$skip_tests"; then
  printf '\n\033[1mPartial run: tests were skipped, no stamp recorded.\033[0m\n'
  exit 0
fi

mkdir -p .dart_tool
"$root/scripts/workspace_hash.sh" > .dart_tool/verify_stamp

printf '\n\033[1;32mAll checks passed.\033[0m\n'
