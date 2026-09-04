import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/onboarding/presentation/screens/permission_screen.dart';

class _FakeMediaPermissionService implements MediaPermissionService {
  _FakeMediaPermissionService({
    this.checkStatus = MediaPermissionStatus.denied,
  });

  final MediaPermissionStatus checkStatus;
  int openSettingsCalls = 0;

  @override
  Future<MediaPermissionStatus> check() async => checkStatus;

  @override
  Future<MediaPermissionStatus> request() async =>
      MediaPermissionStatus.granted;

  @override
  Future<void> openSystemSettings() async {
    openSettingsCalls++;
  }
}

class _FakeNotificationPermissionService
    implements NotificationPermissionService {
  int requestCalls = 0;

  @override
  Future<bool> request() async {
    requestCalls++;
    return true;
  }
}

class _FakeLibraryRepository implements LibraryRepository {
  _FakeLibraryRepository({this.shouldThrow = false});

  bool shouldThrow;
  int reindexCalls = 0;

  /// Held open so a test can observe the screen mid-scan.
  Completer<void>? scanGate;

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
    final gate = scanGate;
    if (gate != null) await gate.future;
    yield const IndexingProgress(processed: 1, total: 1, trackSourceId: 'a');
  }

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> updateTrackTags(
    String trackId, {
    required String title,
    required String artist,
    required String album,
  }) async {}

  @override
  Future<void> clearArtworkCache() async {}
}

Widget _app({
  required _FakeMediaPermissionService permissionService,
  required _FakeLibraryRepository libraryRepository,
  _FakeNotificationPermissionService? notificationService,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: PermissionScreen()),
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) =>
            const Scaffold(body: Text('Home screen reached')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      mediaPermissionServiceProvider.overrideWithValue(permissionService),
      notificationPermissionServiceProvider.overrideWithValue(
        notificationService ?? _FakeNotificationPermissionService(),
      ),
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

  testWidgets('mentions folder exclusion while scanning', (tester) async {
    final permissionService = _FakeMediaPermissionService();
    final libraryRepository = _FakeLibraryRepository()
      ..scanGate = Completer<void>();

    await tester.pumpWidget(
      _app(
        permissionService: permissionService,
        libraryRepository: libraryRepository,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Allow access'));
    await tester.pump();

    expect(
      find.text(
        'Tip: you can exclude folders from your library anytime in '
        'Settings > Storage.',
      ),
      findsOneWidget,
    );

    libraryRepository.scanGate!.complete();
    await tester.pump();
    await tester.pump();
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

  testWidgets('asks for notifications once, before the first scan', (
    tester,
  ) async {
    final notificationService = _FakeNotificationPermissionService();
    final libraryRepository = _FakeLibraryRepository(shouldThrow: true);

    await tester.pumpWidget(
      _app(
        permissionService: _FakeMediaPermissionService(),
        libraryRepository: libraryRepository,
        notificationService: notificationService,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Allow access'));
    await tester.pump();
    await tester.pump();

    expect(notificationService.requestCalls, 1);

    libraryRepository.shouldThrow = false;
    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump();

    expect(notificationService.requestCalls, 1);
    expect(libraryRepository.reindexCalls, 2);
  });

  testWidgets('offers system settings once permission is permanently denied', (
    tester,
  ) async {
    final permissionService = _FakeMediaPermissionService(
      checkStatus: MediaPermissionStatus.permanentlyDenied,
    );

    await tester.pumpWidget(
      _app(
        permissionService: permissionService,
        libraryRepository: _FakeLibraryRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AppPrimaryButton),
        matching: find.text('Open settings'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();

    expect(permissionService.openSettingsCalls, 1);
  });

  testWidgets('keeps granting primary while it can still be granted', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        permissionService: _FakeMediaPermissionService(),
        libraryRepository: _FakeLibraryRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AppPrimaryButton),
        matching: find.text('Allow access'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AppTextButton),
        matching: find.text('Open settings'),
      ),
      findsOneWidget,
    );
  });
}
