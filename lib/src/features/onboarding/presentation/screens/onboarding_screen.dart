import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';

class _Page {
  const _Page(this.artworkSeed, this.title, this.body);

  final String artworkSeed;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) body;
}

final _pages = <_Page>[
  _Page(
    'onboarding-1',
    (l10n) => l10n.onboarding1Title,
    (l10n) => l10n.onboarding1Body,
  ),
  _Page(
    'onboarding-2',
    (l10n) => l10n.onboarding2Title,
    (l10n) => l10n.onboarding2Body,
  ),
  _Page(
    'onboarding-3',
    (l10n) => l10n.onboarding3Title,
    (l10n) => l10n.onboarding3Body,
  ),
];

/// First-run introduction, shown once before the permission screen.
class OnboardingScreen extends StatefulWidget {
  /// Creates an [OnboardingScreen].
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == _pages.length - 1) {
      _finish();
      return;
    }
    unawaited(
      _controller.nextPage(
        duration: AppDurations.base,
        curve: AppCurves.emphasized,
      ),
    );
  }

  void _finish() => context.go(RoutePaths.permissions);

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
                    onPressed: isLastPage ? null : _finish,
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
                    _OnboardingPage(page: _pages[index], l10n: l10n),
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

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.page, required this.l10n});

  final _Page page;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final width = MediaQuery.sizeOf(context).width;
    final artworkSize = (width - 140).clamp(140.0, 260.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.extraLarge),
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
    );
  }
}
