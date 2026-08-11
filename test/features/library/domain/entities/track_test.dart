import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

void main() {
  Track buildTrack({String title = 'Night Drive'}) {
    return Track(
      id: 'track-1',
      sourceId: 'source-1',
      filePath: '/music/night-drive.mp3',
      title: title,
      artistId: 'artist-1',
      albumId: 'album-1',
      duration: const Duration(minutes: 3, seconds: 30),
      format: 'mp3',
      fileSize: 5000000,
      hasEmbeddedArtwork: false,
      dateAdded: DateTime(2026),
      dateModified: DateTime(2026),
    );
  }

  test('two tracks with the same fields are equal', () {
    expect(buildTrack(), buildTrack());
  });

  test('copyWith overrides only the given fields', () {
    final track = buildTrack();
    final renamed = track.copyWith(title: 'Renamed');

    expect(renamed.title, 'Renamed');
    expect(renamed.id, track.id);
    expect(renamed, isNot(track));
  });
}
