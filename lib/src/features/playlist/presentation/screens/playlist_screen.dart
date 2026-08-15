import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/playlist/presentation/providers/playlist_providers.dart';

/// Temporary placeholder for the playlist detail screen.
///
/// Fully built in Fase 15 (track management in Etapa 74, the screen itself
/// in Etapa 75).
class PlaylistScreen extends ConsumerWidget {
  /// Creates a [PlaylistScreen].
  const PlaylistScreen({required this.playlistId, super.key});

  /// The playlist to show.
  final String playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final playlist = ref.watch(playlistByIdProvider(playlistId)).value;

    return AppScaffold(
      topBar: AppTopBar(
        title: playlist?.name,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
