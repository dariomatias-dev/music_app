import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/storage/shared_preferences_storage.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/music_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        keyValueStorageProvider.overrideWithValue(
          SharedPreferencesStorage(preferences),
        ),
      ],
      child: const MusicApp(),
    ),
  );
}
