import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
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

/// App identity, version, a library facts card, and the MIT license text.
class AboutScreen extends ConsumerWidget {
  /// Creates an [AboutScreen].
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final packageInfo = ref.watch(appInfoProvider).value;
    final trackCount = ref.watch(tracksStreamProvider).value?.length ?? 0;
    final albumCount = ref.watch(visibleAlbumsProvider).length;
    final artistCount = ref.watch(visibleArtistsProvider).length;

    Widget fact(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.rowTitle.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );

    return MiniPlayerDock(
      child: AppScaffold(
        topBar: AppTopBar(
          title: l10n.settingsAboutLabel,
          backButtonSemanticLabel: l10n.backButtonSemanticLabel,
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            MiniPlayerDock.insetOf(context),
          ),
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Icon(
                    Icons.music_note_rounded,
                    color: colors.onAccent,
                    size: 27,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.appName,
                        style: AppTypography.section.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      if (packageInfo != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
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
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.settingsSectionLibraryLabel,
              style: AppTypography.section.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Column(
                children: [
                  fact(l10n.libraryTracksTab, '$trackCount'),
                  Divider(color: colors.divider, height: 1),
                  fact(l10n.libraryAlbumsTab, '$albumCount'),
                  Divider(color: colors.divider, height: 1),
                  fact(l10n.libraryArtistsTab, '$artistCount'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.settingsLicenseLabel,
              style: AppTypography.section.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: SelectableText(
                _mitLicenseText,
                style: AppTypography.rowSubtitle.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
