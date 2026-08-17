import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/playback_speed_formatter.dart';
import 'package:music_app/src/features/settings/presentation/view_models/playback_preferences_view_model.dart';

const _speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

/// Shows the playback preferences sheet: gapless, crossfade (with a
/// duration slider once enabled), default speed and haptic feedback.
Future<void> showPlaybackSheet(BuildContext context, WidgetRef ref) {
  return AppBottomSheet.show<void>(
    context,
    builder: (sheetContext) => Consumer(
      builder: (context, ref, _) {
        final l10n = AppLocalizations.of(context)!;
        final colors = context.colors;
        final preferences = ref
            .watch(playbackPreferencesViewModelProvider)
            .value;
        final notifier = ref.read(
          playbackPreferencesViewModelProvider.notifier,
        );

        if (preferences == null) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: AppLoadingIndicator(),
          );
        }

        final crossfading = preferences.crossfadeDuration > Duration.zero;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.smMd,
                AppSpacing.lg,
                AppSpacing.xxs,
              ),
              child: Text(
                l10n.settingsSectionPlaybackLabel,
                style: AppTypography.section.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            _SwitchRow(
              label: l10n.settingsGaplessLabel,
              value: preferences.gaplessEnabled,
              onChanged: crossfading
                  ? null
                  : (enabled) =>
                        unawaited(notifier.setGaplessEnabled(enabled: enabled)),
            ),
            _SwitchRow(
              label: l10n.settingsCrossfadeLabel,
              value: crossfading,
              onChanged: (enabled) => unawaited(
                notifier.setCrossfadeDuration(
                  enabled ? const Duration(seconds: 4) : Duration.zero,
                ),
              ),
            ),
            AnimatedSize(
              duration: AppDurations.base,
              curve: AppCurves.emphasized,
              child: crossfading
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.xs,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Text(
                              '${preferences.crossfadeDuration.inSeconds}s',
                              style: AppTypography.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: colors.textPrimary,
                                inactiveTrackColor: colors.textPrimary
                                    .withValues(alpha: 0.12),
                                thumbColor: colors.textPrimary,
                                overlayColor: colors.textPrimary.withValues(
                                  alpha: 0.08,
                                ),
                                trackHeight: 3,
                              ),
                              child: Slider(
                                min: 1,
                                max: 12,
                                divisions: 11,
                                value: preferences.crossfadeDuration.inSeconds
                                    .toDouble(),
                                onChanged: (value) => unawaited(
                                  notifier.setCrossfadeDuration(
                                    Duration(seconds: value.round()),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.xxs,
              ),
              child: Text(
                l10n.settingsDefaultSpeedLabel,
                style: AppTypography.rowSubtitle.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                children: [
                  for (final speed in _speedOptions)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: _SpeedChip(
                        label: formatPlaybackSpeed(speed),
                        selected: preferences.defaultSpeed == speed,
                        onTap: () => unawaited(notifier.setDefaultSpeed(speed)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _SwitchRow(
              label: l10n.settingsHapticsLabel,
              value: preferences.hapticsEnabled,
              onChanged: (enabled) =>
                  unawaited(notifier.setHapticsEnabled(enabled: enabled)),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        );
      },
    ),
  );
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.rowTitle.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
          AppSwitch(value: value, onChanged: onChanged, semanticLabel: label),
        ],
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  const _SpeedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Pressable(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smMd),
        decoration: BoxDecoration(
          color: selected ? colors.textPrimary : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          label,
          style: AppTypography.rowSubtitle.copyWith(
            color: selected ? colors.background : colors.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
