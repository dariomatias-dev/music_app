import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/player/presentation/view_models/sleep_timer_view_model.dart';

const _presetMinutes = [5, 10, 15, 30, 45, 60];

/// Shows the sleep timer sheet.
Future<void> showSleepTimerSheet(BuildContext context) {
  return AppBottomSheet.show<void>(
    context,
    builder: (sheetContext) => const _SleepTimerSheetContent(),
  );
}

class _SleepTimerSheetContent extends ConsumerWidget {
  const _SleepTimerSheetContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final isActive = ref.watch(sleepTimerViewModelProvider);

    void start(Duration duration) {
      ref.read(sleepTimerViewModelProvider.notifier).start(duration);
      Navigator.of(context).pop();
      AppToast.show(
        context,
        message: l10n.sleepTimerSetMessage,
        variant: AppToastVariant.success,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 2),
          child: Text(
            l10n.sleepTimerSheetTitle,
            style: AppTypography.section.copyWith(color: colors.textPrimary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
          child: Text(
            l10n.sleepTimerSheetBody,
            style: AppTypography.rowSubtitle.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        if (isActive)
          AppSheetAction(
            icon: Icons.timer_off_outlined,
            label: l10n.sleepTimerTurnOffLabel,
            destructive: true,
            onTap: () {
              ref.read(sleepTimerViewModelProvider.notifier).cancel();
              Navigator.of(context).pop();
              AppToast.show(context, message: l10n.sleepTimerOffMessage);
            },
          ),
        for (final minutes in _presetMinutes)
          AppSheetAction(
            icon: Icons.timer_outlined,
            label: '$minutes min',
            onTap: () => start(Duration(minutes: minutes)),
          ),
        AppSheetAction(
          icon: Icons.skip_next_rounded,
          label: l10n.sleepTimerEndOfTrackLabel,
          onTap: () {
            final playback = ref.read(playbackViewModelProvider).value;
            final duration = playback?.duration;
            final position = playback?.position ?? Duration.zero;
            final remaining = duration == null
                ? Duration.zero
                : duration - position;
            start(remaining > Duration.zero ? remaining : Duration.zero);
          },
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
