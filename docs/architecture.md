# Architecture

<p align="center">
<strong>English</strong> · <a href="architecture.es.md">Español</a> · <a href="architecture.pt-BR.md">Português (BR)</a> · <a href="architecture.zh.md">中文</a>
</p>

This document goes one level deeper than the README's overview. It's aimed at anyone changing code in this repo: where a file belongs, why a layer exists, and how the pieces talk to each other.

## Layout

```
lib/
  main.dart                 # composition root: error boundary, platform setup, ProviderScope, RestartWidget
  src/
    core/                   # cross-cutting concerns, shared by every feature
      audio/                # just_audio + audio_service integration
      database/             # drift schema, tables, DAOs, migrations
      navigation/            # go_router config, MainShell, adaptive nav
      permissions/            # media permission abstraction
      services/               # metadata reading/writing, id generation, file pickers, ...
      storage/                # key-value storage abstraction (shared_preferences)
      widgets/                 # small app-wide widgets not tied to a feature
    features/
      <feature>/
        data/                # repositories implementations, data sources, DTOs/mappers
        domain/              # entities, repository interfaces, use cases
        presentation/
          providers/         # derived/presentation state
          screens/           # one file per route
          view_models/       # Notifier/AsyncNotifier classes
          widgets/           # feature-wide widgets, plus one folder per screen
packages/
  app_ui/                    # standalone design-system package (see below)
```

Each feature under `lib/src/features/` is a vertical slice: `library`, `player`, `queue`, `playlist`, `favorites` (part of `library`), `history`, `statistics`, `storage`, `search`, `home`, `settings`, `onboarding`, `splash`.

## Layering (Clean Architecture + MVVM)

Every feature that touches persisted state follows the same three layers:

- **`domain`** — pure Dart. Entities (`freezed` data classes), abstract repository interfaces, and use-case classes (a single `call()` method) for anything with real branching logic (e.g. `CreateBackup`, `RestoreBackup`, `DeleteTrackFile`). No Flutter, no Riverpod, no drift imports here.
- **`data`** — implements the `domain` repository interfaces against a concrete data source (drift DAOs, `shared_preferences`, platform plugins). Mappers convert between drift row types and domain entities.
- **`presentation`** — screens and widgets, plus `ViewModel`s: Riverpod `Notifier`/`AsyncNotifier` classes exposed through generated (`riverpod_generator`) providers. A screen watches providers; it never talks to a repository directly for anything beyond a `ref.read(...)` one-off call triggered by a user action.

A feature only depends on another feature's `domain` layer (entities, repository interfaces), never its `data` or `presentation`. Providers wire the concrete implementation in per-feature `*_data_providers.dart` files.

## Widget organization

Screens stay thin. A screen file watches the providers it needs, owns the callbacks a user action triggers, and composes widgets — nothing it renders is defined inline. Those widgets live under the feature's `presentation/widgets/`, split two ways:

- `widgets/<name>.dart` — shared within the feature: used by more than one screen, or by a sheet or dialog the feature exposes (`media_row.dart`, `playlist_cover_art.dart`, `track_more_sheet.dart`).
- `widgets/<screen_name>/<component>.dart` — owned by a single screen, one public class per file, named for what it renders (`widgets/album_screen/album_header.dart`, `widgets/storage_screen/storage_folder_header.dart`).

Two conventions follow from this:

- **No private widget classes trailing a screen file, and no `_buildX()` helper methods.** Both keep a component from rebuilding independently, and a `_buildX()` method can never be `const`. A component gets a real class in its own file instead.
- **Per-screen components are public** (`AlbumHeader`, not `_AlbumHeader`), since they now cross a file boundary. They stay feature-internal by convention: nothing outside the owning feature imports them. A component that a second feature genuinely needs belongs in `app_ui` if it's presentation-only, or in `lib/src/core/widgets/` if it depends on app state.

A screen file growing past roughly 300–400 lines is the signal that a component is still inlined and should be pulled out.

## State management

[Riverpod](https://riverpod.dev/) end to end, with `riverpod_generator` for the boilerplate:

- `Provider` for stateless dependencies (repositories, use cases).
- `NotifierProvider` / `AsyncNotifierProvider` for anything with behavior (a `ViewModel`).
- `StreamProvider` where a repository already exposes a `Stream` (most `watch*` methods on repositories).

Providers are grouped by role, not by file-per-provider: `library_providers.dart` (derived/presentation state), `library_data_providers.dart` (repositories/data sources), and so on.

## Navigation

[go_router](https://pub.dev/packages/go_router) with a `StatefulShellRoute.indexedStack` for the four main tabs (Home, Search, Library, Settings), each preserving its own navigation stack when switching tabs. `MainShell` (`lib/src/core/navigation/main_shell.dart`) renders that shell, adapting itself with a `LayoutBuilder`:

- Below `AppBreakpoints.medium` (840px): a phone-style bottom navigation bar.
- At or above it (tablets, unfolded foldables): a `NavigationRail` down the side.

Detail routes (album, artist, playlist, player, ...) are pushed on top of the active tab's stack, each wrapped in its own `MiniPlayerDock` so the floating mini-player stays visible.

## Persistence

[drift](https://pub.dev/packages/drift) (a type-safe SQLite layer) backs everything durable: the indexed library (tracks/albums/artists), playlists, favorites, playback history, lyrics cache, search history, and excluded folders. `AppDatabase` (`lib/src/core/database/app_database.dart`) declares the schema and migration strategy; each table has its own `*Table`/`*Dao` pair. User preferences that don't need querying (theme, locale, crossfade duration, ...) go through `shared_preferences` behind a small `KeyValueStorage` abstraction instead.

Two independent backup mechanisms exist, both reachable from Settings → Storage:

- A portable **JSON export** (`CreateBackup`/`RestoreBackup`) of user-created data only — playlists, favorites, history, excluded folders, search history, and preferences — keyed by each track's stable `sourceId` rather than its install-specific internal id, and merged (not replaced) on restore.
- A raw **database file backup** (`CreateDatabaseBackup`/`RestoreDatabaseBackup`), a byte-for-byte `VACUUM INTO` snapshot of the whole SQLite file, including the indexed library. Restoring it replaces the file outright and restarts the app (via `RestartWidget`, a `Key`-swap that tears down and rebuilds the whole `ProviderScope`) to reopen a clean connection.

## Audio

[just_audio](https://pub.dev/packages/just_audio) drives actual playback; [audio_service](https://pub.dev/packages/audio_service) exposes it to the OS (lock screen, notification, Bluetooth controls) through `MusicAudioHandler`. Both the OS-facing metadata and the app's own crossfade effect key off the same upstream signal — `just_audio`'s native `currentIndex` change on a track boundary — so they never drift out of sync with each other.

Crossfade, as implemented today, is a single-player volume ramp: the native engine performs its own instant gapless switch from track A to B, and `PlaybackTransitionEffects` only fades B in from silence afterward — it is not two overlapping audible sources. This is a known simplification, not a bug.

## Error handling

`main.dart` installs the app's outermost boundary before anything else runs. `FlutterError.onError` and `PlatformDispatcher.onError` both route into an `ErrorReporter` (`lib/src/core/errors/`), because both default to printing in debug and doing nothing in release — without them, a widget that throws during build leaves an error box and no trace, and an error escaping a detached async callback disappears outright. The platform handler reports and marks the error handled, so a failure in a plugin's channel or an unlistened stream cannot tear the isolate down and take playback with it.

Two paths surface a failure the user cannot be shielded from, both through `AppFailureScreen` (`lib/src/core/widgets/`): `ErrorWidget.builder`, when a part of a running app fails to build, and the startup fallback, when the platform setup in `main.dart` throws before there is an app at all — the latter offering to run the whole sequence again. Both can be invoked with no `Theme`, `Directionality` or `Localizations` above them, so `AppFailureScreen` resolves all three from the platform rather than from its `BuildContext`; reading a missing ancestor would throw from inside the screen that exists to report the throw.

Within the app, a failure a specific screen can explain stays that screen's business: it catches, shows an `AppToast` or an `AppErrorState`, and does not reach this boundary.

## Design system (`packages/app_ui`)

A self-contained Flutter package, versioned and tested independently of the app (its own CI job, its own coverage threshold). It exports:

- **Tokens**: `AppSpacing`, `AppSizes`, `AppRadius`, `AppDurations`, `AppCurves`, `AppBreakpoints`, typography and color scales.
- **Theme**: light/dark `AppTheme`, exposed to widgets via a `BuildContext` extension (`context.colors`).
- **Components**: buttons, cards, dialogs, sheets, navigation, feedback (toasts), states (empty/error/permission/indexing), and the `Pressable` interaction primitive every tappable widget builds on.

The app never redefines a color, spacing value, or animation curve inline — everything comes from `app_ui`.

## Testing

See the README's Testing section for current file counts and coverage thresholds. In short: unit tests for repositories/use cases/view models, widget tests for screens/components (including golden tests for the design system and key screens), and a handful of `integration_test/` end-to-end flows (onboarding → scan → Home, playback from the library, and data persistence across a simulated restart).
