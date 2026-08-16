import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/settings/presentation/view_models/playback_preferences_view_model.dart';

const List<double> _options = [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];

/// Shows the default playback speed options.
Future<void> showDefaultSpeedSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;

  void select(double speed) {
    unawaited(
      ref
          .read(playbackPreferencesViewModelProvider.notifier)
          .setDefaultSpeed(speed),
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
            l10n.settingsDefaultSpeedLabel,
            style: AppTypography.section.copyWith(
              color: sheetContext.colors.textPrimary,
            ),
          ),
        ),
        for (final speed in _options)
          AppSheetAction(
            icon: Icons.speed_rounded,
            label: '${speed}x',
            onTap: () => select(speed),
          ),
        const SizedBox(height: 6),
      ],
    ),
  );
}
