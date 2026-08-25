import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/settings/presentation/screens/settings_screen.dart';

import '../../../../helpers/fake_key_value_storage.dart';
import '../../../../helpers/pump_golden.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository();

  @override
  Stream<List<Track>> watchTracks() => Stream.value(const []);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

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

Future<void> _pump(WidgetTester tester, {required ThemeData theme}) async {
  final storage = FakeKeyValueStorage();
  await storage.setString('userDisplayName', 'Dario');

  await pumpGoldenScreen(
    tester,
    ProviderScope(
      overrides: [
        libraryRepositoryProvider.overrideWithValue(
          const _FakeLibraryRepository(),
        ),
        keyValueStorageProvider.overrideWithValue(storage),
      ],
      child: const SettingsScreen(),
    ),
    theme: theme,
  );
}

void main() {
  testWidgets('SettingsScreen - light', (tester) async {
    await _pump(tester, theme: AppTheme.light);

    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('goldens/settings_screen_light.png'),
    );
  });

  testWidgets('SettingsScreen - dark', (tester) async {
    await _pump(tester, theme: AppTheme.dark);

    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('goldens/settings_screen_dark.png'),
    );
  });
}
