import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/audio_session_coordinator.dart';
import 'package:music_app/src/core/audio/just_audio_player_service.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/errors/error_handlers.dart';
import 'package:music_app/src/core/errors/error_reporter.dart';
import 'package:music_app/src/core/storage/shared_preferences_storage.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/core/widgets/app_failure_screen.dart';
import 'package:music_app/src/core/widgets/restart_widget.dart';
import 'package:music_app/src/music_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _reporter = LogErrorReporter();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  installErrorHandlers(_reporter);

  ErrorWidget.builder = (details) => AppFailureScreen(
    kind: AppFailureKind.unexpected,
    technicalDetails: details.exceptionAsString(),
  );

  await _start();
}

/// Initializes the platform services the app cannot run without, then
/// hands the tree to [runApp].
///
/// Every step below talks to a plugin that can fail on a real device (a
/// busy audio service, a refused notification channel, an unavailable
/// native library). Left unguarded, any of them would abort before
/// [runApp] and leave a black screen with nothing to act on, so a failure
/// surfaces as a screen offering to run the whole sequence again.
Future<void> _start() async {
  try {
    await MetadataGod.initialize();

    final preferences = await SharedPreferences.getInstance();

    final audioPlayerService = JustAudioPlayerService();

    final audioSessionCoordinator = AudioSessionCoordinator(audioPlayerService);
    await audioSessionCoordinator.initialize();

    final audioHandler = await AudioService.init(
      builder: () => MusicAudioHandler(audioPlayerService),
      config: const AudioServiceConfig(
        androidNotificationChannelName: 'Music App playback',
      ),
    );

    runApp(
      RestartWidget(
        child: ProviderScope(
          overrides: [
            keyValueStorageProvider.overrideWithValue(
              SharedPreferencesStorage(preferences),
            ),
            audioPlayerServiceProvider.overrideWithValue(audioPlayerService),
            audioHandlerProvider.overrideWithValue(audioHandler),
            audioSessionCoordinatorProvider.overrideWithValue(
              audioSessionCoordinator,
            ),
          ],
          child: const MusicApp(),
        ),
      ),
    );
  } on Object catch (error, stackTrace) {
    _reporter.report(error, stackTrace, context: 'Startup failed');
    runApp(
      AppFailureScreen(
        kind: AppFailureKind.startup,
        onRetry: () => unawaited(_start()),
        technicalDetails: error.toString(),
      ),
    );
  }
}
