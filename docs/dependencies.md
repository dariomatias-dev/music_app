# Dependency Notes

<p align="center">
<strong>English</strong> · <a href="dependencies.es.md">Español</a> · <a href="dependencies.pt-BR.md">Português (BR)</a> · <a href="dependencies.zh.md">中文</a>
</p>

Most dependencies in `pubspec.yaml` float on a caret constraint (`^x.y.z`) and get bumped freely. A few (there, and in the Android build files) are pinned to an exact version, or capped below their latest, for reasons that aren't obvious from the constraint alone. This document is that context, so nobody re-discovers it from scratch (or worse, "fixes" the pin without realizing why it's there).

## `intl: 0.20.2` (exact pin)

Forced by `flutter_localizations`, which comes from the Flutter SDK itself rather than pub.dev. The installed Flutter SDK version dictates which `intl` version `flutter_localizations` requires; bumping `intl` on its own without bumping the Flutter SDK first will fail to resolve.

## `drift: 2.31.0`, `drift_dev: 2.31.0` (exact pin, capped below latest)

`drift`/`drift_dev` 2.32.0+ require `analyzer` in the `^10.0.0–^13.0.0` range. `riverpod_generator` (currently `^3.0.0`) transitively depends on `riverpod_analyzer_utils`, which caps `analyzer` well below that (`^7`–`^9` across the versions compatible with `riverpod_generator ^3.0.0`). The two constraints don't overlap, so `drift`/`drift_dev` are held at the last version compatible with the analyzer range `riverpod_generator ^3.0.0` allows.

**This is not a small bump.** Unpinning `drift` requires `drift_dev 2.34+`, which needs `analyzer ^13`. The only `riverpod_analyzer_utils` version that also accepts `analyzer ^13` is `1.0.0-dev.11`, which only ships as a transitive dependency of `riverpod_generator ^4.0.8`. That, in turn, requires `riverpod_annotation ^4.0.6`, a **major version bump of Riverpod itself**, which would also pull `flutter_riverpod` to 4.x and likely touch generated code and provider syntax across the entire app. Track this upstream; don't attempt it as an isolated dependency bump.

## `sqlite3_flutter_libs: 0.5.42` (exact pin, capped below latest)

The package's latest release (`0.6.0+eol`) is an intentional tombstone, an empty package whose description reads *"Not used anymore, update to version 3.x of package:sqlite3 instead."* Its native binaries aren't needed once `sqlite3` (the Dart bindings) moves to its 3.x line, which bundles that responsibility itself.

That migration is **the same blocker as the `drift` pin above**, not a separate one: `sqlite3` 3.x requires `drift ^2.34`, and `drift` 2.31.0 (pinned for the reason above) only accepts `sqlite3 ^2.6`. Resolving the `drift`/Riverpod chain resolves this one too, so don't try to bump `sqlite3_flutter_libs` or `sqlite3` in isolation.

## `gradle-wrapper: 8.14`, `com.android.application: 8.11.1` (capped below latest)

`metadata_god` bundles CargoKit, whose Gradle script calls `exec()`, a method Gradle 9 removed. Any bump to Gradle 9.x fails the APK build with `Could not find method exec() ... on project ':metadata_god'`, so the wrapper stays on the 8.x line until `metadata_god` ships a CargoKit that builds under Gradle 9.

The Android Gradle Plugin is **the same blocker seen from the other side**, not a separate one: AGP 9.x refuses to run on anything below Gradle 9.5.0, failing with `Minimum supported Gradle version is 9.5.0`. Clearing the CargoKit blocker clears this one too, so don't try to bump either past its 9.x boundary in isolation.

The cap is that boundary, not these exact versions. Within 8.x both are free to move, and they sit at the floor Flutter warns it will soon require (Gradle 8.14, AGP 8.11.1, Kotlin 2.2.20), which builds cleanly.

## Checking for updates

```sh
fvm flutter pub outdated
```

Run this occasionally to see what's actually resolvable versus what's blocked by the chains above.

Renovate reads version constraints, not this document, so each chain above is also encoded in [`renovate.json`](../renovate.json): `drift`, `sqlite3`, `intl` and `flutter_rust_bridge` are disabled, and Gradle and the Android Gradle Plugin are capped below 9.x. Lifting a pin means deleting its rule there in the same change that updates this file, so the two never disagree. Renovate's Dependency Dashboard issue lists everything currently held back.
