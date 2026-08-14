import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/services/id_generator/id_generator_provider.dart';
import 'package:music_app/src/core/services/lyrics_reader/lyrics_reader_providers.dart';
import 'package:music_app/src/features/player/data/repositories/lyrics_repository_impl.dart';
import 'package:music_app/src/features/player/domain/repositories/lyrics_repository.dart';

/// Provides the [LyricsRepository] used across the app.
final lyricsRepositoryProvider = Provider<LyricsRepository>(
  (ref) => LyricsRepositoryImpl(
    ref.watch(appDatabaseProvider),
    ref.watch(idGeneratorProvider),
    ref.watch(lyricsReaderProvider),
  ),
);
