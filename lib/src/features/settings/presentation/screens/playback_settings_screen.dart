import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/settings/presentation/view_models/playback_preferences_view_model.dart';
import 'package:music_app/src/features/settings/presentation/widgets/crossfade_duration_sheet.dart';
import 'package:music_app/src/features/settings/presentation/widgets/default_speed_sheet.dart';

/// The playback settings screen: gapless playback, crossfade, default
/// speed and haptic feedback.
class PlaybackSettingsScreen extends ConsumerWidget {
  /// Creates a [PlaybackSettingsScreen].
  const PlaybackSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final preferences = ref.watch(playbackPreferencesViewModelProvider).value;
    final notifier = ref.read(playbackPreferencesViewModelProvider.notifier);
    final crossfading =
        preferences != null && preferences.crossfadeDuration > Duration.zero;

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.settingsSectionPlaybackLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: preferences == null
          ? const AppLoadingIndicator()
          : Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppSectionContainer(
                child: Column(
                  children: [
                    AppSettingsRow(
                      icon: Icons.merge_type_rounded,
                      label: l10n.settingsGaplessLabel,
                      trailing: AppSwitch(
                        value: preferences.gaplessEnabled,
                        onChanged: crossfading
                            ? (_) {}
                            : (enabled) => unawaited(
                                notifier.setGaplessEnabled(enabled: enabled),
                              ),
                      ),
                    ),
                    Divider(height: 1, color: context.colors.divider),
                    AppSettingsRow(
                      icon: Icons.graphic_eq_rounded,
                      label: l10n.settingsCrossfadeLabel,
                      value: crossfading
                          ? '${preferences.crossfadeDuration.inSeconds}s'
                          : l10n.crossfadeOffValue,
                      onTap: () =>
                          unawaited(showCrossfadeDurationSheet(context, ref)),
                    ),
                    Divider(height: 1, color: context.colors.divider),
                    AppSettingsRow(
                      icon: Icons.speed_rounded,
                      label: l10n.settingsDefaultSpeedLabel,
                      value: '${preferences.defaultSpeed}x',
                      onTap: () =>
                          unawaited(showDefaultSpeedSheet(context, ref)),
                    ),
                    Divider(height: 1, color: context.colors.divider),
                    AppSettingsRow(
                      icon: Icons.vibration_rounded,
                      label: l10n.settingsHapticsLabel,
                      trailing: AppSwitch(
                        value: preferences.hapticsEnabled,
                        onChanged: (enabled) => unawaited(
                          notifier.setHapticsEnabled(enabled: enabled),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
