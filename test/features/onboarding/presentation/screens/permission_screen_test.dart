import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/onboarding/presentation/screens/permission_screen.dart';

class _FakeMediaPermissionService implements MediaPermissionService {
  @override
  Future<MediaPermissionStatus> check() async => MediaPermissionStatus.denied;

  @override
  Future<MediaPermissionStatus> request() async =>
      MediaPermissionStatus.granted;

  @override
  Future<void> openSystemSettings() async {}
}

class _FakeLibraryRepository implements LibraryRepository {
  _FakeLibraryRepository({this.shouldThrow = false});

  bool shouldThrow;
  int reindexCalls = 0;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(const []);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() async* {
    reindexCalls++;
    if (shouldThrow) throw Exception('scan boom');
    yield const IndexingProgress(processed: 1, total: 1, trackSourceId: 'a');
  }

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> clearArtworkCache() async {}
}

Widget _app({
  required _FakeMediaPermissionService permissionService,
  required _FakeLibraryRepository libraryRepository,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: PermissionScreen()),
      ),
      GoRoute(
        name: RouteNames.home,
        path: RoutePaths.home,
        builder: (context, state) =>
            const Scaffold(body: Text('Home screen reached')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      mediaPermissionServiceProvider.overrideWithValue(permissionService),
      libraryRepositoryProvider.overrideWithValue(libraryRepository),
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
  testWidgets('grants permission, scans and continues to home', (
    tester,
  ) async {
    final permissionService = _FakeMediaPermissionService();
    final libraryRepository = _FakeLibraryRepository();

    await tester.pumpWidget(
      _app(
        permissionService: permissionService,
        libraryRepository: libraryRepository,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Allow access'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Home screen reached'), findsOneWidget);
  });

  testWidgets('shows an error state with retry when the scan fails', (
    tester,
  ) async {
    final permissionService = _FakeMediaPermissionService();
    final libraryRepository = _FakeLibraryRepository(shouldThrow: true);

    await tester.pumpWidget(
      _app(
        permissionService: permissionService,
        libraryRepository: libraryRepository,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Allow access'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.text('Scan failed'), findsOneWidget);
    expect(find.text('Home screen reached'), findsNothing);

    libraryRepository.shouldThrow = false;
    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Home screen reached'), findsOneWidget);
    expect(libraryRepository.reindexCalls, 2);
  });
}
