import 'dart:async';

import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:flutter/material.dart';

/// A pulsing placeholder box, shown in place of content that has not
/// loaded yet.
class AppSkeleton extends StatefulWidget {
  /// Creates an [AppSkeleton].
  const AppSkeleton({
    this.width,
    this.height = 14,
    this.radius = AppRadius.small,
    super.key,
  });

  /// The placeholder's width. When `null`, fills the available width.
  final double? width;

  /// The placeholder's height.
  final double height;

  /// The placeholder's corner radius.
  final double radius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  bool _reducedMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion == _reducedMotion) return;
    _reducedMotion = reducedMotion;
    if (reducedMotion) {
      _controller.stop();
    } else {
      unawaited(_controller.repeat(reverse: true));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (_reducedMotion) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.4 + 0.3 * _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: colors.surfaceAlt.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
      },
    );
  }
}
