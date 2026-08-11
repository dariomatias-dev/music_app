import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:flutter/material.dart';

/// A single destination of an [AppNavigationBar].
@immutable
class AppNavigationItem {
  /// Creates an [AppNavigationItem].
  const AppNavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  /// Icon shown when this item is not selected.
  final IconData icon;

  /// Icon shown when this item is selected.
  final IconData activeIcon;

  /// The item's text.
  final String label;
}

/// The bottom navigation bar used for the app's main tabs.
class AppNavigationBar extends StatelessWidget {
  /// Creates an [AppNavigationBar].
  const AppNavigationBar({
    required this.items,
    required this.index,
    required this.onChanged,
    super.key,
  });

  /// The bar's destinations.
  final List<AppNavigationItem> items;

  /// The selected item's index.
  final int index;

  /// Called with the new index when an item is tapped.
  final ValueChanged<int> onChanged;

  /// Height of the row itself, before the device's bottom inset.
  static const height = 62.0;

  /// [height] plus the device's bottom safe-area inset.
  static double totalHeight(BuildContext context) =>
      height + MediaQuery.of(context).padding.bottom;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: colors.background,
        boxShadow: [
          // Cast upwards only, just enough to separate the bar from the
          // player tucked underneath it. No divider line.
          BoxShadow(
            color: colors.shadow,
            blurRadius: 18,
            spreadRadius: -2,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: Center(
                  child: _NavigationItemView(
                    item: items[i],
                    active: i == index,
                    onTap: () => onChanged(i),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavigationItemView extends StatelessWidget {
  const _NavigationItemView({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final AppNavigationItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      child: Pressable(
        scale: 0.94,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: AppDurations.resolve(context, AppDurations.base),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Icon(
                  active ? item.activeIcon : item.icon,
                  key: ValueKey(active),
                  size: 22,
                  color: active ? colors.textPrimary : colors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: AppDurations.resolve(context, AppDurations.base),
                style: DefaultTextStyle.of(context).style.copyWith(
                  fontSize: 10.5,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  letterSpacing: -0.1,
                  color: active ? colors.textPrimary : colors.textTertiary,
                ),
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
