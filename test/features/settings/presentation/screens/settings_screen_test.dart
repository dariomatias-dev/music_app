import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/settings/presentation/screens/settings_screen.dart';

import '../../../../helpers/fake_key_value_storage.dart';

class _FakeLibraryRepository implements LibraryRepository {
  int reindexCalls = 0;
  bool reindexShouldThrow = false;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(const []);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() {
    reindexCalls++;
    if (reindexShouldThrow) return Stream.error(Exception('scan boom'));
    return const Stream.empty();
  }

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> clearArtworkCache() async {}
}

Widget _app({
  FakeKeyValueStorage? storage,
  LibraryRepository? libraryRepository,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: SettingsScreen()),
      ),
      GoRoute(
        path: '/settings/language',
        builder: (context, state) =>
            const Scaffold(body: Text('Language screen reached')),
      ),
      GoRoute(
        path: '/settings/playback',
        builder: (context, state) =>
            const Scaffold(body: Text('Playback screen reached')),
      ),
      GoRoute(
        path: '/storage',
        builder: (context, state) =>
            const Scaffold(body: Text('Storage screen reached')),
      ),
      GoRoute(
        path: '/statistics',
        builder: (context, state) =>
            const Scaffold(body: Text('Statistics screen reached')),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) =>
            const Scaffold(body: Text('About screen reached')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      keyValueStorageProvider.overrideWithValue(
        storage ?? FakeKeyValueStorage(),
      ),
      libraryRepositoryProvider.overrideWithValue(
        libraryRepository ?? _FakeLibraryRepository(),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  setUp(() {
    // The default 800x600 test surface leaves the last rows a few pixels
    // short now that rows have more generous padding.
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
          ..physicalSize = const Size(800, 1000)
          ..devicePixelRatio = 1;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  });

  testWidgets('shows every section title', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Playback'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('shows a placeholder name and the system language by default', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Not set'), findsOneWidget);
    expect(find.text('System default'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
  });

  testWidgets('shows the stored display name', (tester) async {
    final storage = FakeKeyValueStorage();
    await storage.setString('userDisplayName', 'Dário');

    await tester.pumpWidget(_app(storage: storage));
    await tester.pump();

    expect(find.text('Dário'), findsOneWidget);
  });

  testWidgets('editing the name saves it and updates the row', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await tester.pumpWidget(_app(storage: storage));
    await tester.pump();

    await tester.tap(find.text('Not set'));
    await tester.pumpAndSettle();

    expect(find.text('Your name'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Dário');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Dário'), findsOneWidget);
    expect(await storage.getString('userDisplayName'), 'Dário');
  });

  testWidgets('clearing the name in the sheet removes it', (tester) async {
    final storage = FakeKeyValueStorage();
    await storage.setString('userDisplayName', 'Dário');
    await tester.pumpWidget(_app(storage: storage));
    await tester.pump();

    await tester.tap(find.text('Dário'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Not set'), findsOneWidget);
    expect(await storage.getString('userDisplayName'), isNull);
  });

  testWidgets('selecting a theme from the sheet persists it', (tester) async {
    final storage = FakeKeyValueStorage();
    await tester.pumpWidget(_app(storage: storage));
    await tester.pump();

    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();

    expect(find.text('Dark'), findsOneWidget);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(find.text('Dark'), findsOneWidget);
    expect(await storage.getString('themeMode'), 'dark');
  });

  testWidgets('tapping Language opens the language settings route', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    expect(find.text('Language screen reached'), findsOneWidget);
  });

  testWidgets('tapping the playback row opens the playback settings route', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('Gapless, crossfade & speed'));
    await tester.pumpAndSettle();

    expect(find.text('Playback screen reached'), findsOneWidget);
  });

  testWidgets('tapping Storage opens the storage route', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('Storage'));
    await tester.pumpAndSettle();

    expect(find.text('Storage screen reached'), findsOneWidget);
  });

  testWidgets('tapping Statistics opens the statistics route', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('Statistics'));
    await tester.pumpAndSettle();

    expect(find.text('Statistics screen reached'), findsOneWidget);
  });

  testWidgets('tapping the about row opens the about route', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('App info & version'));
    await tester.pumpAndSettle();

    expect(find.text('About screen reached'), findsOneWidget);
  });

  testWidgets('tapping Rescan library triggers a reindex', (tester) async {
    final libraryRepository = _FakeLibraryRepository();
    await tester.pumpWidget(_app(libraryRepository: libraryRepository));
    await tester.pump();

    await tester.tap(find.text('Rescan library'));
    await tester.pumpAndSettle();

    expect(libraryRepository.reindexCalls, 1);
    expect(find.text('Library rescanned'), findsOneWidget);
  });

  testWidgets('shows an error toast and clears busy when rescan fails', (
    tester,
  ) async {
    final libraryRepository = _FakeLibraryRepository()
      ..reindexShouldThrow = true;
    await tester.pumpWidget(_app(libraryRepository: libraryRepository));
    await tester.pump();

    await tester.tap(find.text('Rescan library'));
    await tester.pumpAndSettle();

    expect(
      find.text('Something went wrong while scanning your music library.'),
      findsOneWidget,
    );

    // Not stuck busy: a second tap reaches the repository again.
    await tester.tap(find.text('Rescan library'));
    await tester.pumpAndSettle();
    expect(libraryRepository.reindexCalls, 2);
  });
}
