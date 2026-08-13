import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';

/// Shell of the app's four main tabs, preserving each tab's navigation
/// state when switching between them.
class MainShell extends StatelessWidget {
  /// Creates a [MainShell].
  const MainShell({required this.navigationShell, super.key});

  /// The active tab and its navigation state.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          const SizedBox(height: AppSpacing.smMd),
          AppNavigationBar(
            items: [
              AppNavigationItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: l10n.homeTabLabel,
              ),
              AppNavigationItem(
                icon: Icons.search,
                activeIcon: Icons.search,
                label: l10n.searchTabLabel,
              ),
              AppNavigationItem(
                icon: Icons.library_music_outlined,
                activeIcon: Icons.library_music,
                label: l10n.libraryTabLabel,
              ),
              AppNavigationItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: l10n.settingsTabLabel,
              ),
            ],
            index: navigationShell.currentIndex,
            onChanged: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),
        ],
      ),
    );
  }
}
