import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/services/lyrics_reader/file_lyrics_reader.dart';
import 'package:path/path.dart' as p;

List<int> _synchsafe(int value) {
  return [
    (value >> 21) & 0x7F,
    (value >> 14) & 0x7F,
    (value >> 7) & 0x7F,
    value & 0x7F,
  ];
}

List<int> _bigEndian(int value) {
  return [
    (value >> 24) & 0xFF,
    (value >> 16) & 0xFF,
    (value >> 8) & 0xFF,
    value & 0xFF,
  ];
}

/// Encodes [text] as UTF-16, optionally prefixed by a byte order mark.
List<int> _utf16(String text, {required bool bigEndian, List<int>? bom}) {
  final bytes = <int>[...?bom];
  for (final unit in text.codeUnits) {
    bytes.addAll(
      bigEndian ? [unit >> 8, unit & 0xFF] : [unit & 0xFF, unit >> 8],
    );
  }
  return bytes;
}

/// Builds an ID3v2.3 tag whose USLT frame carries UTF-16 [lyrics].
///
/// Encoding 1 is UTF-16 with a BOM; encoding 2 is UTF-16BE without one.
Uint8List _mp3WithUtf16Uslt(
  String lyrics, {
  required int encoding,
  required bool bigEndian,
  bool withBom = true,
  bool terminateDescription = true,
}) {
  final bom = !withBom
      ? null
      : bigEndian
      ? [0xFE, 0xFF]
      : [0xFF, 0xFE];
  final frameContent = [
    encoding,
    ...utf8.encode('eng'),
    if (terminateDescription) ...[0x00, 0x00],
    ..._utf16(lyrics, bigEndian: bigEndian, bom: bom),
  ];
  final frame = [
    ...utf8.encode('USLT'),
    ..._bigEndian(frameContent.length),
    0,
    0,
    ...frameContent,
  ];
  final header = [
    ...utf8.encode('ID3'),
    3,
    0,
    0,
    ..._synchsafe(frame.length),
  ];
  return Uint8List.fromList([...header, ...frame]);
}

Uint8List _mp3WithUslt(
  String lyrics, {
  int encoding = 3,
  bool synchsafeFrameSize = false,
  bool frameUnsynchronized = false,
}) {
  final textBytes = switch (encoding) {
    0 => latin1.encode(lyrics),
    3 => utf8.encode(lyrics),
    _ => throw UnsupportedError('Test helper only covers encodings 0 and 3'),
  };
  final frameContent = [encoding, ...utf8.encode('eng'), 0x00, ...textBytes];
  final frameSizeBytes = synchsafeFrameSize
      ? _synchsafe(frameContent.length)
      : _bigEndian(frameContent.length);
  final frame = [
    ...utf8.encode('USLT'),
    ...frameSizeBytes,
    0,
    if (frameUnsynchronized) 0x02 else 0x00,
    ...frameContent,
  ];
  final header = [
    ...utf8.encode('ID3'),
    3, 0, // major version 3, revision 0
    0, // flags
    ..._synchsafe(frame.length),
  ];
  return Uint8List.fromList([...header, ...frame]);
}

void main() {
  late Directory tempDir;
  late FileLyricsReader reader;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('lyrics_reader_test');
    reader = const FileLyricsReader();
  });

  tearDown(() => tempDir.delete(recursive: true));

  group('readEmbedded', () {
    test('reads a UTF-8 USLT frame from an ID3v2.3 tag', () async {
      final file = File(p.join(tempDir.path, 'song.mp3'));
      await file.writeAsBytes(_mp3WithUslt('Line one\nLine two'));

      expect(await reader.readEmbedded(file.path), 'Line one\nLine two');
    });

    test('reads a Latin-1 USLT frame', () async {
      final file = File(p.join(tempDir.path, 'song.mp3'));
      await file.writeAsBytes(_mp3WithUslt('Café', encoding: 0));

      expect(await reader.readEmbedded(file.path), 'Café');
    });

    test('reads a UTF-16 USLT frame with a big-endian BOM', () async {
      final file = File(p.join(tempDir.path, 'song.mp3'));
      await file.writeAsBytes(
        _mp3WithUtf16Uslt('Canção', encoding: 1, bigEndian: true),
      );

      expect(await reader.readEmbedded(file.path), 'Canção');
    });

    test('reads a UTF-16 USLT frame with a little-endian BOM', () async {
      final file = File(p.join(tempDir.path, 'song.mp3'));
      await file.writeAsBytes(
        _mp3WithUtf16Uslt('Canção', encoding: 1, bigEndian: false),
      );

      expect(await reader.readEmbedded(file.path), 'Canção');
    });

    test('reads a UTF-16BE USLT frame, which carries no BOM', () async {
      final file = File(p.join(tempDir.path, 'song.mp3'));
      await file.writeAsBytes(
        _mp3WithUtf16Uslt(
          'Canção',
          encoding: 2,
          bigEndian: true,
          withBom: false,
        ),
      );

      expect(await reader.readEmbedded(file.path), 'Canção');
    });

    test(
      'returns null when a UTF-16 description is never terminated',
      () async {
        final file = File(p.join(tempDir.path, 'song.mp3'));
        await file.writeAsBytes(
          _mp3WithUtf16Uslt(
            'Canção',
            encoding: 1,
            bigEndian: true,
            terminateDescription: false,
          ),
        );

        expect(await reader.readEmbedded(file.path), isNull);
      },
    );

    test('returns null for an unknown text encoding', () async {
      final file = File(p.join(tempDir.path, 'song.mp3'));
      await file.writeAsBytes(
        _mp3WithUtf16Uslt('Ignored', encoding: 9, bigEndian: true),
      );

      expect(await reader.readEmbedded(file.path), isNull);
    });

    test('returns null for non-mp3 files', () async {
      final file = File(p.join(tempDir.path, 'song.flac'));
      await file.writeAsBytes(_mp3WithUslt('Ignored'));

      expect(await reader.readEmbedded(file.path), isNull);
    });

    test('returns null when there is no ID3 tag', () async {
      final file = File(p.join(tempDir.path, 'song.mp3'));
      await file.writeAsBytes([0xFF, 0xFB, 0x90, 0x00]);

      expect(await reader.readEmbedded(file.path), isNull);
    });

    test('returns null for a missing file', () async {
      final missing = p.join(tempDir.path, 'missing.mp3');

      expect(await reader.readEmbedded(missing), isNull);
    });
  });

  group('readSidecar', () {
    test('reads a matching .lrc file', () async {
      final audio = p.join(tempDir.path, 'song.mp3');
      await File(p.join(tempDir.path, 'song.lrc')).writeAsString(
        '[00:01.00]Line one\n[00:05.00]Line two',
      );

      expect(
        await reader.readSidecar(audio),
        '[00:01.00]Line one\n[00:05.00]Line two',
      );
    });

    test('returns null when no sidecar file exists', () async {
      final audio = p.join(tempDir.path, 'song.mp3');

      expect(await reader.readSidecar(audio), isNull);
    });
  });
}
