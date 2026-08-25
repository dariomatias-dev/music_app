import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:metadata_god/metadata_god.dart' as metadata_god;
import 'package:music_app/src/core/services/metadata_reader/metadata_writer.dart';

void main() {
  test('writes the given title, artist and album to the file', () async {
    metadata_god.Metadata? written;
    String? writtenFile;
    final writer = MetadataGodWriter(
      readRaw: ({required file}) async => const metadata_god.Metadata(),
      writeRaw: ({required file, required metadata}) async {
        writtenFile = file;
        written = metadata;
      },
    );

    await writer.writeTags(
      '/music/night-drive.mp3',
      title: 'New title',
      artist: 'New artist',
      album: 'New album',
    );

    expect(writtenFile, '/music/night-drive.mp3');
    expect(written!.title, 'New title');
    expect(written!.artist, 'New artist');
    expect(written!.album, 'New album');
  });

  test('preserves every other existing tag and the embedded artwork', () async {
    metadata_god.Metadata? written;
    final picture = metadata_god.Picture(
      data: Uint8List.fromList([1, 2, 3]),
      mimeType: 'image/jpeg',
    );
    final writer = MetadataGodWriter(
      readRaw: ({required file}) async => metadata_god.Metadata(
        albumArtist: 'Original Album Artist',
        trackNumber: 3,
        trackTotal: 10,
        discNumber: 1,
        discTotal: 2,
        year: 2024,
        genre: 'Electronic',
        durationMs: 252000,
        fileSize: BigInt.from(1000),
        picture: picture,
      ),
      writeRaw: ({required file, required metadata}) async {
        written = metadata;
      },
    );

    await writer.writeTags(
      '/music/night-drive.mp3',
      title: 'New title',
      artist: 'New artist',
      album: 'New album',
    );

    expect(written!.albumArtist, 'Original Album Artist');
    expect(written!.trackNumber, 3);
    expect(written!.trackTotal, 10);
    expect(written!.discNumber, 1);
    expect(written!.discTotal, 2);
    expect(written!.year, 2024);
    expect(written!.genre, 'Electronic');
    expect(written!.durationMs, 252000);
    expect(written!.fileSize, BigInt.from(1000));
    expect(written!.picture, picture);
  });
}
