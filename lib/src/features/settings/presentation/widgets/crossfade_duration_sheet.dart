import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/settings/presentation/view_models/playback_preferences_view_model.dart';

const List<Duration> _options = [
  Duration.zero,
  Duration(seconds: 2),
  Duration(seconds: 4),
  Duration(seconds: 6),
  Duration(seconds: 8),
  Duration(seconds: 12),
];

/// Shows the crossfade duration options.
Future<void> showCrossfadeDurationSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;

  void select(Duration duration) {
    unawaited(
      ref
          .read(playbackPreferencesViewModelProvider.notifier)
          .setCrossfadeDuration(duration),
    );
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
            l10n.settingsCrossfadeLabel,
            style: AppTypography.section.copyWith(
              color: sheetContext.colors.textPrimary,
            ),
          ),
        ),
        for (final duration in _options)
          AppSheetAction(
            icon: Icons.graphic_eq_rounded,
            label: duration == Duration.zero
                ? l10n.crossfadeOffValue
                : '${duration.inSeconds}s',
            onTap: () => select(duration),
          ),
        const SizedBox(height: 6),
      ],
    ),
  );
}
