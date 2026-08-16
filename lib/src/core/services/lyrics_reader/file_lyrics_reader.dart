import 'dart:convert';
import 'dart:io';

import 'package:music_app/src/core/services/lyrics_reader/lyrics_reader.dart';
import 'package:path/path.dart' as p;

/// Reads embedded ID3v2 `USLT` lyrics frames and sidecar `.lrc` files.
///
/// Embedded reading only supports MP3's ID3v2.3/2.4 tags (unsynchronised
/// tags and frames are skipped), since that's the format lyrics taggers
/// target in practice; other containers (FLAC, M4A, Ogg, …) rely on a
/// sidecar `.lrc` file instead, which is read for every format. Any
/// malformed or unsupported tag yields `null` rather than throwing.
class FileLyricsReader implements LyricsReader {
  /// Creates a [FileLyricsReader].
  const FileLyricsReader();

  @override
  Future<String?> readEmbedded(String filePath) async {
    if (p.extension(filePath).toLowerCase() != '.mp3') return null;
    try {
      return await _readId3UsltLyrics(filePath);
      // Malformed binary tags can trip Errors (e.g. RangeError), not just
      // Exceptions; any failure here just means "no lyrics found".
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<String?> readSidecar(String filePath) async {
    final file = File(p.setExtension(filePath, '.lrc'));
    if (!file.existsSync()) return null;
    try {
      final content = await file.readAsString();
      return content.trim().isEmpty ? null : content;
      // A sidecar file that isn't readable or valid text just means "no
      // lyrics found" rather than a failure worth surfacing.
    } on Object catch (_) {
      return null;
    }
  }

  Future<String?> _readId3UsltLyrics(String filePath) async {
    final raf = await File(filePath).open();
    try {
      final header = await raf.read(10);
      if (header.length < 10 ||
          header[0] != 0x49 ||
          header[1] != 0x44 ||
          header[2] != 0x33) {
        return null;
      }

      final majorVersion = header[3];
      if (majorVersion != 3 && majorVersion != 4) return null;

      final tagFlags = header[5];
      final unsynchronized = (tagFlags & 0x80) != 0;
      final hasExtendedHeader = (tagFlags & 0x40) != 0;
      if (unsynchronized || hasExtendedHeader) return null;

      final tagSize = _synchsafeToInt(header.sublist(6, 10));
      final body = await raf.read(tagSize);

      var offset = 0;
      while (offset + 10 <= body.length) {
        final frameId = String.fromCharCodes(
          body.sublist(offset, offset + 4),
        );
        if (frameId == '\x00\x00\x00\x00') break;

        final frameSize = majorVersion == 4
            ? _synchsafeToInt(body.sublist(offset + 4, offset + 8))
            : _bigEndianToInt(body.sublist(offset + 4, offset + 8));
        final frameFlags = body.sublist(offset + 8, offset + 10);
        final frameStart = offset + 10;
        final frameEnd = frameStart + frameSize;
        if (frameSize <= 0 || frameEnd > body.length) break;

        if (frameId == 'USLT') {
          final frameUnsynchronized =
              majorVersion == 4 && (frameFlags[1] & 0x02) != 0;
          if (!frameUnsynchronized) {
            final lyrics = _decodeUslt(body.sublist(frameStart, frameEnd));
            if (lyrics != null && lyrics.trim().isNotEmpty) return lyrics;
          }
        }

        offset = frameEnd;
      }
      return null;
    } finally {
      await raf.close();
    }
  }

  int _synchsafeToInt(List<int> bytes) {
    var value = 0;
    for (final byte in bytes) {
      value = (value << 7) | (byte & 0x7F);
    }
    return value;
  }

  int _bigEndianToInt(List<int> bytes) {
    var value = 0;
    for (final byte in bytes) {
      value = (value << 8) | byte;
    }
    return value;
  }

  /// Decodes a `USLT` frame's content: 1 encoding byte, 3 language bytes,
  /// a null-terminated description, then the lyrics text.
  String? _decodeUslt(List<int> data) {
    if (data.length < 4) return null;
    final encoding = data[0];
    const offset = 4;

    switch (encoding) {
      case 0:
      case 3:
        final descEnd = data.indexOf(0x00, offset);
        if (descEnd == -1) return null;
        final textBytes = data.sublist(descEnd + 1);
        return encoding == 0
            ? latin1.decode(textBytes)
            : utf8.decode(textBytes, allowMalformed: true);
      case 1:
      case 2:
        return _decodeUtf16Uslt(data, offset, hasBom: encoding == 1);
      default:
        return null;
    }
  }

  String? _decodeUtf16Uslt(
    List<int> data,
    int start, {
    required bool hasBom,
  }) {
    var descEnd = -1;
    for (var i = start; i + 1 < data.length; i += 2) {
      if (data[i] == 0x00 && data[i + 1] == 0x00) {
        descEnd = i;
        break;
      }
    }
    if (descEnd == -1) return null;

    var bytes = data.sublist(descEnd + 2);
    if (bytes.isEmpty) return null;

    var bigEndian = !hasBom;
    if (hasBom && bytes.length >= 2) {
      if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
        bigEndian = true;
        bytes = bytes.sublist(2);
      } else if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
        bigEndian = false;
        bytes = bytes.sublist(2);
      }
    }

    final codeUnits = <int>[];
    for (var i = 0; i + 1 < bytes.length; i += 2) {
      codeUnits.add(
        bigEndian
            ? (bytes[i] << 8) | bytes[i + 1]
            : (bytes[i + 1] << 8) | bytes[i],
      );
    }
    return String.fromCharCodes(codeUnits);
  }
}
