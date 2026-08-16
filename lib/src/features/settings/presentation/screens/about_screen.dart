import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:music_app/src/features/settings/data/providers/app_info_provider.dart';

/// Mirrors the project's root `LICENSE` file.
const _mitLicenseText = '''
MIT License

Copyright (c) 2026 Dario Matias

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.''';

/// App identity, version, a shortcut to replay onboarding, and the MIT
/// license text.
class AboutScreen extends ConsumerWidget {
  /// Creates an [AboutScreen].
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final packageInfo = ref.watch(appInfoProvider).value;

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.settingsAboutLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(AppRadius.large),
                  ),
                  child: Icon(
                    Icons.music_note_rounded,
                    size: 36,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.appName,
                  style: AppTypography.header.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                if (packageInfo != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.settingsVersionValue(
                      packageInfo.version,
                      packageInfo.buildNumber,
                    ),
                    style: AppTypography.rowSubtitle.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppSectionContainer(
            child: AppSettingsRow(
              icon: Icons.replay_rounded,
              label: l10n.settingsReplayOnboardingLabel,
              onTap: () => unawaited(_replayOnboarding(context, ref)),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              bottom: AppSpacing.xs,
            ),
            child: Text(
              l10n.settingsLicenseLabel,
              style: AppTypography.section.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          AppSectionContainer(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SelectableText(
                _mitLicenseText,
                style: AppTypography.rowSubtitle.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _replayOnboarding(BuildContext context, WidgetRef ref) async {
    await ref.read(onboardingViewModelProvider.notifier).reset();
    if (!context.mounted) return;
    context.go(RoutePaths.onboarding);
  }
}
