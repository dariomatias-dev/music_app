import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_screen_view_model.dart';

/// The playback ("Now Playing") screen.
///
/// Fully built across later stages: cover, track info, progress bar,
/// controls and contextual actions.
class PlaybackScreen extends ConsumerWidget {
  /// Creates a [PlaybackScreen].
  const PlaybackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentItem = ref.watch(playbackScreenViewModelProvider);

    return AppScaffold(
      topBar: AppTopBar(
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: currentItem == null
          ? AppEmptyState(
              icon: Icons.music_off_outlined,
              title: l10n.playbackEmptyTitle,
              message: l10n.playbackEmptyMessage,
            )
          : const SizedBox.shrink(),
    );
  }
}
