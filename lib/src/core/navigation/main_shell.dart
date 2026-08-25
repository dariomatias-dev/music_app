import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';

/// Shell of the app's four main tabs, preserving each tab's navigation
/// state when switching between them.
///
/// Below [AppBreakpoints.medium] this is a phone-style bottom navigation
/// bar; at and above it, a side [NavigationRail] takes over, since there's
/// room for one and it keeps more of the screen for content.
class MainShell extends StatelessWidget {
  /// Creates a [MainShell].
  const MainShell({required this.navigationShell, super.key});

  /// The active tab and its navigation state.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
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
    ];

    void onChanged(int index) => navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.medium) {
          return _WideShell(
            navigationShell: navigationShell,
            items: items,
            onChanged: onChanged,
          );
        }
        return _CompactShell(
          navigationShell: navigationShell,
          items: items,
          onChanged: onChanged,
        );
      },
    );
  }
}

class _CompactShell extends StatelessWidget {
  const _CompactShell({
    required this.navigationShell,
    required this.items,
    required this.onChanged,
  });

  final StatefulNavigationShell navigationShell;
  final List<AppNavigationItem> items;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          const SizedBox(height: AppSpacing.smMd),
          AppNavigationBar(
            items: items,
            index: navigationShell.currentIndex,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _WideShell extends StatelessWidget {
  const _WideShell({
    required this.navigationShell,
    required this.items,
    required this.onChanged,
  });

  final StatefulNavigationShell navigationShell;
  final List<AppNavigationItem> items;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: onChanged,
            labelType: NavigationRailLabelType.all,
            backgroundColor: colors.background,
            destinations: [
              for (final item in items)
                NavigationRailDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.activeIcon),
                  label: Text(item.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                Expanded(child: navigationShell),
                const MiniPlayer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
