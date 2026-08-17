import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';

/// Library-wide counts (tracks, albums, artists), total duration, and
/// access to the storage screen.
class HomeLibrarySummary extends ConsumerWidget {
  /// Creates a [HomeLibrarySummary].
  const HomeLibrarySummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tracks = ref.watch(tracksStreamProvider).value ?? const [];
    final albums = ref.watch(albumsStreamProvider).value ?? const [];
    final artists = ref.watch(artistsStreamProvider).value ?? const [];

    final visibleTracks = tracks.where((track) => !track.isMissing);
    final totalDuration = visibleTracks.fold(
      Duration.zero,
      (total, track) => total + track.duration,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  value: '${visibleTracks.length}',
                  label: l10n.libraryTracksTab,
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: _StatTile(
                  value: '${albums.length}',
                  label: l10n.libraryAlbumsTab,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.smMd),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  value: '${artists.length}',
                  label: l10n.libraryArtistsTab,
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: _StatTile(
                  value: formatLongDuration(totalDuration),
                  label: l10n.libraryTotalDurationLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.smMd),
          _LinkRow(
            icon: Icons.bar_chart_rounded,
            label: l10n.statisticsLabel,
            onTap: () => context.push(RoutePaths.statistics),
          ),
          const SizedBox(height: AppSpacing.smMd),
          _LinkRow(
            icon: Icons.sd_storage_outlined,
            label: l10n.storageLabel,
            onTap: () => context.push(RoutePaths.storage),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.smMd,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.header.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Pressable(
      scale: 0.99,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smMd,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.textSecondary),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Text(
                label,
                style: AppTypography.rowTitle.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
