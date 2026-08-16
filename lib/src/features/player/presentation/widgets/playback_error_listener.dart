import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';

/// Surfaces playback engine failures (e.g. a corrupt or missing file) as
/// an error toast.
///
/// [AudioPlayerService.errorStream] otherwise has no user-visible effect;
/// wrap the app's root with this so it stays mounted for the whole session.
class PlaybackErrorListener extends ConsumerWidget {
  /// Creates a [PlaybackErrorListener].
  const PlaybackErrorListener({required this.child, super.key});

  /// The wrapped subtree.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(playbackErrorProvider, (previous, next) {
      if (next.value == null) return;
      final l10n = AppLocalizations.of(context)!;
      AppToast.show(
        context,
        message: l10n.playbackErrorMessage,
        variant: AppToastVariant.error,
      );
    });
    return child;
  }
}
