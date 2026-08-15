import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/features/history/presentation/view_models/playback_history_recorder.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// Splash screen shown while the app's core dependencies (preferences,
/// database) finish initializing.
///
/// Once ready, it hands off navigation to [RoutePaths.home]; the router's
/// redirect then sends the user to onboarding, permissions or home.
class SplashScreen extends ConsumerStatefulWidget {
  /// Creates a [SplashScreen].
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepare());
  }

  Future<void> _prepare() async {
    await ref.read(appDatabaseProvider).trackDao.getAll();
    ref.read(playbackHistoryRecorderProvider);
    unawaited(ref.read(queueViewModelProvider.notifier).restoreSession());
    if (!mounted) return;
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.appName,
              style: AppTypography.display.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const AppLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
