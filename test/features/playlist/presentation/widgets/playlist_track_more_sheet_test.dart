import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_track_more_sheet.dart';

import '../../../../helpers/fake_playlist_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.tracks);

  final List<Track> tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

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

Track _track() {
  return Track(
    id: 'track-1',
    sourceId: 'track-1',
    filePath: '/music/night-drive.flac',
    title: 'Night Drive',
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'flac',
    fileSize: 12000000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

/// Opens the sheet for a single-track playlist.
Future<void> _openSheet(
  WidgetTester tester, {
  required FakePlaylistRepository playlistRepository,
  required String playlistId,
}) async {
  final track = _track();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        playlistRepositoryProvider.overrideWithValue(playlistRepository),
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository([track]),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () => showPlaylistTrackMoreSheet(
                  context,
                  ref,
                  playlistId: playlistId,
                  track: track,
                  artistName: 'Charcoal',
                  playlistTracks: [track],
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  late FakePlaylistRepository repository;
  late String playlistId;

  setUp(() async {
    repository = FakePlaylistRepository();
    playlistId = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(playlistId, ['track-1']);
  });

  testWidgets('shows the track and every action', (tester) async {
    await _openSheet(
      tester,
      playlistRepository: repository,
      playlistId: playlistId,
    );

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Charcoal'), findsOneWidget);
    expect(find.text('Add to playlist'), findsOneWidget);
    expect(find.text('Remove from playlist'), findsOneWidget);
    expect(find.text('File information'), findsOneWidget);
  });

  testWidgets('add to playlist closes the sheet and opens the picker', (
    tester,
  ) async {
    await _openSheet(
      tester,
      playlistRepository: repository,
      playlistId: playlistId,
    );

    await tester.tap(find.text('Add to playlist'));
    await tester.pumpAndSettle();

    expect(find.text('Remove from playlist'), findsNothing);
    expect(find.text('Road Trip'), findsOneWidget);
  });

  testWidgets('file information closes the sheet and opens the dialog', (
    tester,
  ) async {
    await _openSheet(
      tester,
      playlistRepository: repository,
      playlistId: playlistId,
    );

    await tester.tap(find.text('File information'));
    await tester.pumpAndSettle();

    expect(find.text('Remove from playlist'), findsNothing);
    expect(find.textContaining('FLAC'), findsOneWidget);
  });

  testWidgets('removing asks for confirmation before dropping the track', (
    tester,
  ) async {
    await _openSheet(
      tester,
      playlistRepository: repository,
      playlistId: playlistId,
    );

    await tester.tap(find.text('Remove from playlist'));
    await tester.pumpAndSettle();
    expect(find.text('Remove track?'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(AppDialog),
        matching: find.text('Delete'),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      await repository.watchPlaylistTrackIds(playlistId).first,
      isEmpty,
    );
  });
}
