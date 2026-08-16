import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
import '../../../../helpers/pump_golden.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository();

  @override
  Stream<List<Track>> watchTracks() => Stream.value([
    Track(
      id: 'track-1',
      sourceId: 'track-1',
      filePath: '/music/night-drive.mp3',
      title: 'Night Drive',
      artistId: 'artist-1',
      albumId: 'album-1',
      duration: const Duration(minutes: 4, seconds: 12),
      format: 'mp3',
      fileSize: 4200000,
      hasEmbeddedArtwork: false,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(0),
      dateModified: DateTime.fromMillisecondsSinceEpoch(0),
    ),
  ]);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const [
    Album(
      id: 'album-1',
      sourceId: 'album-1',
      title: 'Chill Vibes',
      artistId: 'artist-1',
      trackCount: 1,
      totalDuration: Duration(minutes: 4, seconds: 12),
    ),
  ]);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const [
    Artist(
      id: 'artist-1',
      sourceId: 'artist-1',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 1,
    ),
  ]);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> clearArtworkCache() async {}
}

Future<void> _pump(WidgetTester tester, {required ThemeData theme}) async {
  final storage = FakeKeyValueStorage();
  await storage.setString('userDisplayName', 'Dario');
  final playlistRepository = FakePlaylistRepository();
  await playlistRepository.createPlaylist('Road Trip');

  await pumpGoldenScreen(
    tester,
    ProviderScope(
      overrides: [
        libraryRepositoryProvider.overrideWithValue(
          const _FakeLibraryRepository(),
        ),
        keyValueStorageProvider.overrideWithValue(storage),
        playHistoryRepositoryProvider.overrideWithValue(
          FakePlayHistoryRepository(const ['track-1']),
        ),
        playlistRepositoryProvider.overrideWithValue(playlistRepository),
      ],
      child: const HomeScreen(),
    ),
    theme: theme,
  );
}

void main() {
  testWidgets('HomeScreen - populated - light', (tester) async {
    await _pump(tester, theme: AppTheme.light);

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('goldens/home_screen_light.png'),
    );
  });

  testWidgets('HomeScreen - populated - dark', (tester) async {
    await _pump(tester, theme: AppTheme.dark);

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('goldens/home_screen_dark.png'),
    );
  });
}
