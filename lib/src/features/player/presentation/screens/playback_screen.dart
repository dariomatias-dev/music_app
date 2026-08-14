import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_screen_view_model.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_controls.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_cover.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_progress_bar.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_speed_control.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_track_info.dart';

/// The playback ("Now Playing") screen.
///
/// Fully built across later stages: track info, progress bar, controls and
/// contextual actions.
class PlaybackScreen extends ConsumerWidget {
  /// Creates a [PlaybackScreen].
  const PlaybackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentItem = ref.watch(playbackScreenViewModelProvider);
    final playing = ref.watch(
      playbackViewModelProvider.select((state) => state.value?.playing),
    );

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
          : Column(
              children: [
                const Spacer(flex: 2),
                Center(
                  child: PlaybackCover(
                    item: currentItem,
                    playing: playing ?? false,
                  ),
                ),
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: PlaybackTrackInfo(item: currentItem),
                ),
                const SizedBox(height: AppSpacing.lgXl),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: PlaybackProgressBar(item: currentItem),
                ),
                const SizedBox(height: AppSpacing.lgXl),
                const PlaybackControls(),
                const SizedBox(height: AppSpacing.sm),
                const PlaybackSpeedControl(),
                const Spacer(flex: 3),
              ],
            ),
    );
  }
}
