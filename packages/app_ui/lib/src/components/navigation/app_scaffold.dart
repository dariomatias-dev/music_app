import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:flutter/material.dart';

/// A top bar plus its scrollable content, with a hairline that fades in
/// once the content has scrolled under the bar.
///
/// Used by every screen so headers behave identically everywhere.
class AppScaffold extends StatefulWidget {
  /// Creates an [AppScaffold].
  const AppScaffold({required this.topBar, required this.body, super.key});

  /// The screen's top bar.
  final Widget topBar;

  /// The screen's scrollable content.
  final Widget body;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  double _dividerOpacity = 0;

  bool _handleScroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    final next = (notification.metrics.pixels / 24).clamp(0.0, 1.0);
    if ((next - _dividerOpacity).abs() > 0.02) {
      setState(() => _dividerOpacity = next);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          widget.topBar,
          SizedBox(
            height: 1,
            child: AnimatedOpacity(
              opacity: _dividerOpacity,
              duration: AppDurations.resolve(context, AppDurations.fast),
              child: ColoredBox(color: colors.divider),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: _handleScroll,
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }
}
