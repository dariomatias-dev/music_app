import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/onboarding/presentation/widgets/onboarding_screen/onboarding_page_data.dart';

/// One page of the onboarding intro: artwork, title and body text.
class OnboardingPage extends StatelessWidget {
  /// Creates an [OnboardingPage].
  const OnboardingPage({required this.page, required this.l10n, super.key});

  /// The page's content.
  final OnboardingPageData page;

  /// The active localization, used to resolve [page]'s text.
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final width = MediaQuery.sizeOf(context).width;
    final artworkSize = (width - 140).clamp(140.0, 260.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      // On short screens the artwork, title and body together can exceed
      // the space PageView gives this page; scroll instead of overflowing,
      // while still centering when everything already fits.
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppRadius.extraLarge,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 40,
                        spreadRadius: -8,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: AppArtwork(
                    seed: page.artworkSeed,
                    size: artworkSize,
                    radius: AppRadius.extraLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  page.title(l10n),
                  textAlign: TextAlign.center,
                  style: AppTypography.display.copyWith(
                    fontSize: 25,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.smMd),
                Text(
                  page.body(l10n),
                  textAlign: TextAlign.center,
                  style: AppTypography.rowSubtitle.copyWith(
                    fontSize: 14,
                    height: 1.55,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
