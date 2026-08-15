import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/storage/data/providers/storage_data_providers.dart';
import 'package:music_app/src/features/storage/domain/delete_track_file.dart';
import 'package:music_app/src/features/storage/presentation/screens/storage_screen.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_excluded_folder_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  _FakeLibraryRepository({this.tracks = const []});

  final List<Track> tracks;
  int reindexCalls = 0;
  bool artworkCacheCleared = false;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() {
    reindexCalls++;
    return const Stream.empty();
  }

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> clearArtworkCache() async {
    artworkCacheCleared = true;
  }
}

class _FakeDeleteTrackFile implements DeleteTrackFile {
  final List<Track> deleted = [];
  bool shouldThrow = false;

  @override
  Future<void> call(Track track) async {
    if (shouldThrow) throw Exception('boom');
    deleted.add(track);
  }
}

Track _track(String id, {required String filePath, int fileSize = 1000}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: filePath,
    title: 'Track $id',
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: fileSize,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

Widget _app({
  _FakeLibraryRepository? libraryRepository,
  FakeExcludedFolderRepository? excludedFolderRepository,
  DeleteTrackFile? deleteTrackFile,
}) {
  final playerService = FakeAudioPlayerService();
  return ProviderScope(
    overrides: [
      libraryRepositoryProvider.overrideWithValue(
        libraryRepository ?? _FakeLibraryRepository(),
      ),
      excludedFolderRepositoryProvider.overrideWithValue(
        excludedFolderRepository ?? FakeExcludedFolderRepository(),
      ),
      if (deleteTrackFile != null)
        deleteTrackFileProvider.overrideWithValue(deleteTrackFile),
      audioPlayerServiceProvider.overrideWithValue(playerService),
      audioHandlerProvider.overrideWithValue(MusicAudioHandler(playerService)),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: StorageScreen()),
    ),
  );
}

void main() {
  testWidgets('shows the empty state when there are no tracks', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('No tracks yet'), findsOneWidget);
  });

  testWidgets('shows total space used and each folder', (tester) async {
    await tester.pumpWidget(
      _app(
        libraryRepository: _FakeLibraryRepository(
          tracks: [
            _track('a', filePath: '/music/rock/a.mp3'),
            _track('b', filePath: '/music/pop/b.mp3', fileSize: 2000),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('2.9 KB'), findsOneWidget);
    expect(find.text('rock'), findsOneWidget);
    expect(find.text('pop'), findsOneWidget);
  });

  testWidgets('expanding a folder shows its files', (tester) async {
    await tester.pumpWidget(
      _app(
        libraryRepository: _FakeLibraryRepository(
          tracks: [_track('a', filePath: '/music/rock/a.mp3', fileSize: 500)],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Track a'), findsNothing);

    await tester.tap(find.text('rock'));
    await tester.pumpAndSettle();

    expect(find.text('Track a'), findsOneWidget);
  });

  testWidgets('toggling a folder off excludes it and triggers a rescan', (
    tester,
  ) async {
    final libraryRepository = _FakeLibraryRepository(
      tracks: [_track('a', filePath: '/music/rock/a.mp3')],
    );
    final excludedFolderRepository = FakeExcludedFolderRepository();
    await tester.pumpWidget(
      _app(
        libraryRepository: libraryRepository,
        excludedFolderRepository: excludedFolderRepository,
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();

    expect(
      await excludedFolderRepository.watchExcludedFolders().first,
      ['/music/rock'],
    );
    expect(libraryRepository.reindexCalls, 1);
  });

  testWidgets('clearing artwork cache calls it after confirming', (
    tester,
  ) async {
    final libraryRepository = _FakeLibraryRepository(
      tracks: [_track('a', filePath: '/music/rock/a.mp3')],
    );
    await tester.pumpWidget(_app(libraryRepository: libraryRepository));
    await tester.pump();

    await tester.tap(find.text('Clear artwork cache'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(libraryRepository.artworkCacheCleared, isTrue);
  });

  testWidgets('deleting a file removes it after confirming', (tester) async {
    final deleteTrackFile = _FakeDeleteTrackFile();
    await tester.pumpWidget(
      _app(
        libraryRepository: _FakeLibraryRepository(
          tracks: [_track('a', filePath: '/music/rock/a.mp3')],
        ),
        deleteTrackFile: deleteTrackFile,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('rock'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(deleteTrackFile.deleted.map((t) => t.id), ['a']);
    expect(find.text('File deleted'), findsOneWidget);
  });

  testWidgets('shows an error toast when deletion fails', (tester) async {
    final deleteTrackFile = _FakeDeleteTrackFile()..shouldThrow = true;
    await tester.pumpWidget(
      _app(
        libraryRepository: _FakeLibraryRepository(
          tracks: [_track('a', filePath: '/music/rock/a.mp3')],
        ),
        deleteTrackFile: deleteTrackFile,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('rock'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't delete this file"), findsOneWidget);
  });
}
