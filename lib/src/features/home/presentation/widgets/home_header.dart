import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/navigators/main_shell_navigator.dart';
import 'package:music_app/src/core/utils/clock.dart';
import 'package:music_app/src/features/settings/presentation/view_models/user_profile_view_model.dart';

/// The Home tab's header: a time-of-day greeting with the user's name (once
/// set, in Etapa 91), and a tappable trigger that switches to the Search
/// tab.
class HomeHeader extends ConsumerWidget {
  /// Creates a [HomeHeader].
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final name = ref.watch(userProfileViewModelProvider).value;
    final now = ref.watch(clockProvider)();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name == null || name.isEmpty)
            Text(
              l10n.homeWelcomeLabel,
              style: AppTypography.display.copyWith(color: colors.textPrimary),
            )
          else ...[
            Text(
              _greeting(l10n, now),
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textSecondary,
              ),
            ),
            Text(
              name,
              style: AppTypography.display.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _SearchTrigger(hint: l10n.searchTriggerHintLabel),
        ],
      ),
    );
  }

  String _greeting(AppLocalizations l10n, DateTime now) {
    final hour = now.hour;
    if (hour < 12) return l10n.goodMorningLabel;
    if (hour < 18) return l10n.goodAfternoonLabel;
    return l10n.goodEveningLabel;
  }
}

class _SearchTrigger extends StatelessWidget {
  const _SearchTrigger({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Pressable(
      scale: 0.98,
      onTap: () => MainShellNavigator.goToSearchTab(context),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 18, color: colors.textTertiary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              hint,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
