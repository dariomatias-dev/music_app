import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner.dart';
import 'package:music_app/src/core/services/media_scanner/on_audio_query_media_scanner.dart';
import 'package:on_audio_query/on_audio_query.dart';

final _onAudioQueryProvider = Provider<OnAudioQuery>((ref) => OnAudioQuery());

/// Provides the [MediaScanner] used across the app.
final mediaScannerProvider = Provider<MediaScanner>(
  (ref) => OnAudioQueryMediaScanner(
    ref.watch(_onAudioQueryProvider),
    ref.watch(mediaPermissionServiceProvider),
  ),
);
