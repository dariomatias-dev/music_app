import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/utils/lyrics_parser.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';

/// Scrolling list of lyric lines. Follows playback position and
/// highlights the active line when the lyrics carry LRC timestamps;
/// tapping a timed line seeks to it.
class LyricsList extends ConsumerStatefulWidget {
  /// Creates a [LyricsList].
  const LyricsList({required this.lines, super.key});

  /// The parsed lyric lines to display, in order.
  final List<LyricLine> lines;

  @override
  ConsumerState<LyricsList> createState() => _LyricsListState();
}

class _LyricsListState extends ConsumerState<LyricsList> {
  static const _lineExtent = 48.0;

  final _scrollController = ScrollController();
  var _lastActiveIndex = -1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _followActiveLine(int index) {
    if (!mounted ||
        index == _lastActiveIndex ||
        !_scrollController.hasClients) {
      return;
    }
    _lastActiveIndex = index;
    final target = (index * _lineExtent - 140.0).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    unawaited(
      _scrollController.animateTo(
        target,
        duration: AppDurations.slow,
        curve: AppCurves.emphasized,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final position =
        ref.watch(
          playbackViewModelProvider.select((state) => state.value?.position),
        ) ??
        Duration.zero;
    final synced = widget.lines.first.timestamp != null;
    final activeIndex = activeLyricLineIndex(widget.lines, position);

    if (synced && activeIndex >= 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _followActiveLine(activeIndex),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemExtent: _lineExtent,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      itemCount: widget.lines.length,
      itemBuilder: (context, index) {
        final line = widget.lines[index];
        final isActive = synced && index == activeIndex;

        return Pressable(
          scale: 0.98,
          onTap: line.timestamp == null
              ? null
              : () => unawaited(
                  ref.read(audioPlayerServiceProvider).seek(line.timestamp!),
                ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedDefaultTextStyle(
              duration: AppDurations.base,
              curve: AppCurves.emphasized,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.header.copyWith(
                fontSize: isActive ? 20 : 17,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? colors.textPrimary : colors.textSecondary,
              ),
              child: Text(line.text),
            ),
          ),
        );
      },
    );
  }
}
