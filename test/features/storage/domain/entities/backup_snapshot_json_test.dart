import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_playlist.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_settings.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_snapshot.dart';

void main() {
  test(
    'a snapshot with playlists survives the jsonEncode/jsonDecode round '
    'trip a real export/import performs',
    () {
      final snapshot = BackupSnapshot(
        formatVersion: 1,
        createdAt: DateTime(2026, 3, 5, 12, 30),
        playlists: const [
          BackupPlaylist(
            name: 'Road trip',
            isFavorite: true,
            trackSourceIds: ['charcoal', 'ember'],
            description: 'For the drive',
          ),
          BackupPlaylist(
            name: 'Focus',
            isFavorite: false,
            trackSourceIds: [],
          ),
        ],
        favoriteTrackSourceIds: const ['charcoal'],
        excludedFolders: const ['/music/podcasts'],
        searchHistoryTerms: const ['jazz'],
        settings: const BackupSettings(
          gaplessEnabled: true,
          crossfadeDurationSeconds: 3,
          defaultPlaybackSpeed: 1.25,
          hapticsEnabled: false,
          locale: 'pt',
          themeMode: 'dark',
          userDisplayName: 'Dario',
        ),
      );

      final json = jsonEncode(snapshot.toJson());
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final restored = BackupSnapshot.fromJson(decoded);

      expect(restored, snapshot);
      expect(restored.playlists, hasLength(2));
      expect(restored.playlists.first.trackSourceIds, [
        'charcoal',
        'ember',
      ]);
      expect(restored.playlists.last.description, isNull);
    },
  );
}
