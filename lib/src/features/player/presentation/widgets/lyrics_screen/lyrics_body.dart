import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/utils/lyrics_parser.dart';
import 'package:music_app/src/features/player/domain/entities/lyrics.dart';
import 'package:music_app/src/features/player/presentation/providers/lyrics_providers.dart';
import 'package:music_app/src/features/player/presentation/widgets/lyrics_screen/lyrics_empty_state.dart';
import 'package:music_app/src/features/player/presentation/widgets/lyrics_screen/lyrics_list.dart';

/// Loads and parses the current track's lyrics, then shows the scrolling
/// list or an empty state depending on what was found.
class LyricsBody extends ConsumerWidget {
  /// Creates a [LyricsBody].
  const LyricsBody({required this.item, super.key});

  /// The track whose lyrics should be shown.
  final QueueMediaItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lyricsAsync = ref.watch(lyricsProvider(item.id, item.filePath));

    return lyricsAsync.when(
      loading: () => const AppLoadingIndicator(),
      error: (error, stackTrace) => LyricsEmptyState(l10n: l10n),
      data: (lyrics) {
        final content = lyrics.content;
        final lines = lyrics.source == LyricsSource.none || content == null
            ? const <LyricLine>[]
            : parseLyricLines(content);
        if (lines.isEmpty) return LyricsEmptyState(l10n: l10n);
        return LyricsList(lines: lines);
      },
    );
  }
}
