import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Switches between the main shell's branches (Home, Search, Library,
/// Settings).
abstract final class MainShellNavigator {
  /// Index of the Search tab within the shell's branches (home, search,
  /// library, settings, in that order).
  static const _searchTabIndex = 1;

  /// Switches to the Search tab.
  static void goToSearchTab(BuildContext context) {
    StatefulNavigationShell.of(context).goBranch(_searchTabIndex);
  }
}
