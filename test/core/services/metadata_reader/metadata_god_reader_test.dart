import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:metadata_god/metadata_god.dart' as metadata_god;
import 'package:music_app/src/core/services/metadata_reader/metadata_god_reader.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_reader.dart';

/// Builds a reader answering with [metadata], recording the paths it is
/// asked about.
({MetadataGodReader reader, List<String> paths}) readerReturning(
  metadata_god.Metadata metadata,
) {
  final paths = <String>[];
  return (
    reader: MetadataGodReader(
      readRaw: ({required file}) async {
        paths.add(file);
        return metadata;
      },
    ),
    paths: paths,
  );
}

/// Builds a reader whose underlying call fails.
MetadataGodReader readerThrowing(Exception error) {
  return MetadataGodReader(
    readRaw: ({required file}) async => throw error,
  );
}

void main() {
  test('passes the file path through to the underlying reader', () async {
    final (:reader, :paths) = readerReturning(const metadata_god.Metadata());

    await reader.read('/music/night-drive.mp3');

    expect(paths, ['/music/night-drive.mp3']);
  });

  test('maps every tag onto the track metadata', () async {
    final (:reader, :paths) = readerReturning(
      const metadata_god.Metadata(
        title: 'Night Drive',
        artist: 'Charcoal',
        album: 'Chill Vibes',
        albumArtist: 'Charcoal',
        trackNumber: 3,
        discNumber: 1,
        year: 2024,
        genre: 'Electronic',
        durationMs: 252000,
      ),
    );

    final metadata = await reader.read('/music/night-drive.mp3');

    expect(metadata.title, 'Night Drive');
    expect(metadata.artist, 'Charcoal');
    expect(metadata.album, 'Chill Vibes');
    expect(metadata.albumArtist, 'Charcoal');
    expect(metadata.trackNumber, 3);
    expect(metadata.discNumber, 1);
    expect(metadata.year, 2024);
    expect(metadata.genre, 'Electronic');
    expect(metadata.duration, const Duration(minutes: 4, seconds: 12));
  });

  test('leaves absent tags null', () async {
    final (:reader, :paths) = readerReturning(const metadata_god.Metadata());

    final metadata = await reader.read('/music/untagged.mp3');

    expect(metadata.title, isNull);
    expect(metadata.artist, isNull);
    expect(metadata.duration, isNull);
    expect(metadata.artwork, isNull);
  });

  group('embedded artwork', () {
    test('carries the picture bytes and its mime type', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final (:reader, :paths) = readerReturning(
        metadata_god.Metadata(
          picture: metadata_god.Picture(
            data: bytes,
            mimeType: 'image/jpeg',
          ),
        ),
      );

      final metadata = await reader.read('/music/night-drive.mp3');

      expect(metadata.artwork, isNotNull);
      expect(metadata.artwork!.data, bytes);
      expect(metadata.artwork!.mimeType, 'image/jpeg');
    });

    test('is null when the file carries no picture', () async {
      final (:reader, :paths) = readerReturning(const metadata_god.Metadata());

      expect((await reader.read('/music/a.mp3')).artwork, isNull);
    });
  });

  group('an unreadable file', () {
    test('yields empty metadata instead of throwing', () async {
      final reader = readerThrowing(Exception('corrupt'));

      await expectLater(reader.read('/music/broken.mp3'), completes);
      expect(await reader.read('/music/broken.mp3'), isA<TrackMetadata>());
    });

    test('yields no tags at all', () async {
      final reader = readerThrowing(Exception('corrupt'));

      final metadata = await reader.read('/music/broken.mp3');

      expect(metadata.title, isNull);
      expect(metadata.artist, isNull);
      expect(metadata.album, isNull);
      expect(metadata.duration, isNull);
      expect(metadata.artwork, isNull);
    });
  });
}
