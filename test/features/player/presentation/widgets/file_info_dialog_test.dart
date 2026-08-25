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
import 'package:music_app/src/features/player/presentation/widgets/file_info_dialog.dart';

class _FakeLibraryRepository implements LibraryRepository {
  _FakeLibraryRepository(this.tracks);

  final List<Track> tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Album>> watchAlbums() => const Stream.empty();

  @override
  Stream<List<Artist>> watchArtists() => const Stream.empty();

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

Track _track({
  int? bitrate,
  int? sampleRate,
}) {
  return Track(
    id: 'track-1',
    sourceId: 'track-1',
    filePath: '/music/night-drive.flac',
    title: 'Night Drive',
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'flac',
    fileSize: 5242880,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
    bitrate: bitrate,
    sampleRate: sampleRate,
  );
}

Widget _app(LibraryRepository repository) {
  return ProviderScope(
    overrides: [libraryRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () => showFileInfoDialog(context, ref, 'track-1'),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows format, size and path, skipping absent bitrate/rate', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(_FakeLibraryRepository([_track()])),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('File information'), findsOneWidget);
    expect(
      find.text(
        'Format: FLAC\n'
        'Size: 5.0 MB\n'
        'Path: /music/night-drive.flac',
      ),
      findsOneWidget,
    );
  });

  testWidgets('includes bitrate and sample rate when present', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        _FakeLibraryRepository([
          _track(bitrate: 320000, sampleRate: 44100),
        ]),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Format: FLAC\n'
        'Size: 5.0 MB\n'
        'Bitrate: 320 kbps\n'
        'Sample rate: 44100 Hz\n'
        'Path: /music/night-drive.flac',
      ),
      findsOneWidget,
    );
  });

  testWidgets('does nothing when the track id is not found', (tester) async {
    await tester.pumpWidget(_app(_FakeLibraryRepository(const [])));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('File information'), findsNothing);
  });
}
