import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/services/id_generator/id_generator_provider.dart';
import 'package:music_app/src/features/playlist/data/repositories/playlist_repository_impl.dart';
import 'package:music_app/src/features/playlist/domain/repositories/playlist_repository.dart';

/// Provides the [PlaylistRepository] used across the app.
final playlistRepositoryProvider = Provider<PlaylistRepository>(
  (ref) => PlaylistRepositoryImpl(
    ref.watch(appDatabaseProvider),
    ref.watch(idGeneratorProvider),
  ),
);
