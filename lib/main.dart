import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/just_audio_player_service.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/storage/shared_preferences_storage.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/music_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MetadataGod.initialize();

  final preferences = await SharedPreferences.getInstance();

  final audioPlayerService = JustAudioPlayerService();
  final audioHandler = await AudioService.init(
    builder: () => MusicAudioHandler(audioPlayerService),
    config: const AudioServiceConfig(
      androidNotificationChannelName: 'Music App playback',
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        keyValueStorageProvider.overrideWithValue(
          SharedPreferencesStorage(preferences),
        ),
        audioPlayerServiceProvider.overrideWithValue(audioPlayerService),
        audioHandlerProvider.overrideWithValue(audioHandler),
      ],
      child: const MusicApp(),
    ),
  );
}
