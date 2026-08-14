import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/utils/lyrics_parser.dart';
import 'package:music_app/src/features/player/domain/entities/lyrics.dart';
import 'package:music_app/src/features/player/presentation/providers/lyrics_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_screen_view_model.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';

/// Shows the current track's lyrics.
///
/// Scrolls in sync with playback when the lyrics carry LRC timestamps, and
/// tapping a synced line seeks to it. Falls back to a static list when
/// there's no timing information, and to an empty state when nothing was
/// found.
class LyricsScreen extends ConsumerWidget {
  /// Creates a [LyricsScreen].
  const LyricsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentItem = ref.watch(playbackScreenViewModelProvider);

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.openLyricsLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: currentItem == null
          ? AppEmptyState(
              icon: Icons.music_off_outlined,
              title: l10n.playbackEmptyTitle,
              message: l10n.playbackEmptyMessage,
            )
          : _LyricsBody(item: currentItem),
    );
  }
}

class _LyricsBody extends ConsumerWidget {
  const _LyricsBody({required this.item});

  final QueueMediaItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lyricsAsync = ref.watch(lyricsProvider(item.id, item.filePath));

    return lyricsAsync.when(
      loading: () => const AppLoadingIndicator(),
      error: (error, stackTrace) => _LyricsEmptyState(l10n: l10n),
      data: (lyrics) {
        final content = lyrics.content;
        final lines = lyrics.source == LyricsSource.none || content == null
            ? const <LyricLine>[]
            : parseLyricLines(content);
        if (lines.isEmpty) return _LyricsEmptyState(l10n: l10n);
        return _LyricsList(lines: lines);
      },
    );
  }
}

class _LyricsEmptyState extends StatelessWidget {
  const _LyricsEmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.lyrics_outlined,
      title: l10n.lyricsEmptyTitle,
      message: l10n.lyricsEmptyMessage,
    );
  }
}

class _LyricsList extends ConsumerStatefulWidget {
  const _LyricsList({required this.lines});

  final List<LyricLine> lines;

  @override
  ConsumerState<_LyricsList> createState() => _LyricsListState();
}

class _LyricsListState extends ConsumerState<_LyricsList> {
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
