import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/presentation/view_models/track_sort_view_model.dart';

/// Shows the Tracks tab's sort options.
Future<void> showTrackSortSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;

  void select(TrackSort sort) {
    ref.read(trackSortViewModelProvider.notifier).order = sort;
    Navigator.of(context).pop();
  }

  return AppBottomSheet.show<void>(
    context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 2),
          child: Text(
            l10n.sortSheetTitle,
            style: AppTypography.section.copyWith(
              color: sheetContext.colors.textPrimary,
            ),
          ),
        ),
        AppSheetAction(
          icon: Icons.sort_by_alpha_rounded,
          label: l10n.sortByTitleLabel,
          onTap: () => select(TrackSort.title),
        ),
        AppSheetAction(
          icon: Icons.person_outline,
          label: l10n.sortByArtistLabel,
          onTap: () => select(TrackSort.artist),
        ),
        AppSheetAction(
          icon: Icons.calendar_today_outlined,
          label: l10n.sortByDateAddedLabel,
          onTap: () => select(TrackSort.dateAdded),
        ),
        AppSheetAction(
          icon: Icons.timer_outlined,
          label: l10n.sortByDurationLabel,
          onTap: () => select(TrackSort.duration),
        ),
        const SizedBox(height: 6),
      ],
    ),
  );
}
