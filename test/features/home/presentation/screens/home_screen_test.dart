import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/home/presentation/screens/home_screen.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';

import '../../../../helpers/fake_key_value_storage.dart';
import '../../../../helpers/fake_play_history_repository.dart';
import '../../../../helpers/fake_playlist_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.tracks);

  final List<Track> tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => const Stream.empty();

  @override
  Stream<List<Album>> watchAlbums() => const Stream.empty();

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}
}

Track _track(String id) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: id,
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

Widget _app(List<Track> tracks, {FakeKeyValueStorage? storage}) {
  return ProviderScope(
    overrides: [
      libraryRepositoryProvider.overrideWithValue(
        _FakeLibraryRepository(tracks),
      ),
      keyValueStorageProvider.overrideWithValue(
        storage ?? FakeKeyValueStorage(),
      ),
      playHistoryRepositoryProvider.overrideWithValue(
        FakePlayHistoryRepository(),
      ),
      playlistRepositoryProvider.overrideWithValue(
        FakePlaylistRepository(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    ),
  );
}

void main() {
  testWidgets('shows a loading indicator before the library responds', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const []));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the empty state when the library has no tracks', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const []));
    await tester.pump();

    expect(find.text('Your library is empty'), findsOneWidget);
  });

  testWidgets('shows no empty state when the library has tracks', (
    tester,
  ) async {
    await tester.pumpWidget(_app([_track('track-1')]));
    await tester.pump();

    expect(find.text('Your library is empty'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows a name-less welcome when no display name is set', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const []));
    await tester.pump();

    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('shows a time-of-day greeting with the display name', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await storage.setString('userDisplayName', 'Dário');

    await tester.pumpWidget(_app(const [], storage: storage));
    await tester.pump();

    expect(find.text('Dário'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
  });

  testWidgets('shows the search trigger', (tester) async {
    await tester.pumpWidget(_app(const []));
    await tester.pump();

    expect(find.text('Search your library'), findsOneWidget);
  });
}
