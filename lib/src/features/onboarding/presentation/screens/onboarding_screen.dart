import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/navigators/onboarding_navigator.dart';
import 'package:music_app/src/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:music_app/src/features/onboarding/presentation/widgets/onboarding_screen/onboarding_page.dart';
import 'package:music_app/src/features/onboarding/presentation/widgets/onboarding_screen/onboarding_page_data.dart';

final _pages = <OnboardingPageData>[
  OnboardingPageData(
    'onboarding-1',
    (l10n) => l10n.onboarding1Title,
    (l10n) => l10n.onboarding1Body,
  ),
  OnboardingPageData(
    'onboarding-2',
    (l10n) => l10n.onboarding2Title,
    (l10n) => l10n.onboarding2Body,
  ),
  OnboardingPageData(
    'onboarding-3',
    (l10n) => l10n.onboarding3Title,
    (l10n) => l10n.onboarding3Body,
  ),
];

/// First-run introduction, shown once before the permission screen.
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Creates an [OnboardingScreen].
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == _pages.length - 1) {
      unawaited(_finish());
      return;
    }
    unawaited(
      _controller.nextPage(
        duration: AppDurations.base,
        curve: AppCurves.emphasized,
      ),
    );
  }

  Future<void> _finish() async {
    await ref.read(onboardingViewModelProvider.notifier).complete();
    if (!mounted) return;
    OnboardingNavigator.goToPermissions(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final isLastPage = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedOpacity(
                opacity: isLastPage ? 0 : 1,
                duration: AppDurations.base,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 12, 0),
                  child: AppTextButton(
                    label: l10n.onboardingSkip,
                    onPressed: isLastPage ? null : () => unawaited(_finish()),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (page) => setState(() => _page = page),
                itemCount: _pages.length,
                itemBuilder: (context, index) =>
                    OnboardingPage(page: _pages[index], l10n: l10n),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  AnimatedContainer(
                    duration: AppDurations.base,
                    curve: AppCurves.emphasized,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _page ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _page
                          ? colors.textPrimary
                          : colors.textPrimary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lgXl,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  label: isLastPage
                      ? l10n.onboardingStartListening
                      : l10n.onboardingNext,
                  icon: isLastPage
                      ? Icons.play_arrow_rounded
                      : Icons.arrow_forward_rounded,
                  height: 52,
                  onPressed: _next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
