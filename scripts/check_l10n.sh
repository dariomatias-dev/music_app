#!/usr/bin/env bash
#
# Fails when the localized ARB files disagree on which keys they carry.
#
# Every user-facing string ships in all four languages, and nothing else
# enforces that: gen-l10n falls back to the template for a missing key and
# says nothing, so a half-translated change reaches users as English text in
# a Spanish build.
#
# Usage: scripts/check_l10n.sh [arb-dir]

set -euo pipefail

export LC_ALL=C

readonly arb_dir="${1:-lib/l10n}"
readonly template="$arb_dir/app_en.arb"

if [[ ! -f "$template" ]]; then
  echo "No template ARB at $template." >&2
  exit 1
fi

# Message keys only. The two-space anchor keeps this to the top level of the
# JSON object: `placeholders` and `count` sit deeper, inside the `@key`
# blocks, and describe a message rather than being one. `@@locale` and the
# `@key` entries themselves are skipped for the same reason.
keys_of() {
  grep -oE '^  "[^@"][^"]*"[[:space:]]*:' "$1" |
    tr -d ' ":' |
    sort
}

readonly expected="$(keys_of "$template")"
readonly total="$(wc -l <<< "$expected")"
status=0

for file in "$arb_dir"/app_*.arb; do
  [[ "$file" == "$template" ]] && continue

  actual="$(keys_of "$file")"
  missing="$(comm -23 <(echo "$expected") <(echo "$actual"))"
  extra="$(comm -13 <(echo "$expected") <(echo "$actual"))"

  if [[ -n "$missing" || -n "$extra" ]]; then
    status=1
    echo "$file" >&2
    [[ -n "$missing" ]] && sed 's/^/  missing: /' <<< "$missing" >&2
    [[ -n "$extra" ]] && sed 's/^/  not in the template: /' <<< "$extra" >&2
  fi
done

if (( status != 0 )); then
  echo "" >&2
  echo "Every string ships in all four languages. Add the keys above, then" >&2
  echo "run 'fvm flutter gen-l10n'." >&2
  exit 1
fi

echo "Localizations: $total keys, matching across every ARB file."
