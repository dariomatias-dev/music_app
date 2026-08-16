import 'dart:async';

import 'package:app_ui/src/tokens/app_curves.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Scales down while pressed, standardizing the touch response of every
/// interactive element.
class Pressable extends StatefulWidget {
  /// Creates a [Pressable].
  const Pressable({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = 0.96,
    this.haptic = true,
    super.key,
  });

  /// The wrapped widget.
  final Widget child;

  /// Called when tapped. When `null`, the widget does not respond to taps.
  final VoidCallback? onTap;

  /// Called on a long press.
  final VoidCallback? onLongPress;

  /// Scale applied while pressed.
  final double scale;

  /// Whether a light haptic impact fires on tap.
  final bool haptic;

  /// App-wide switch for haptic feedback, honored in addition to [haptic].
  ///
  /// Design-system widgets have no access to app-level preferences, so the
  /// app sets this directly whenever the user's haptics preference
  /// changes, rather than threading it through every tappable widget.
  static bool hapticsEnabled = true;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _isPressed = false;

  void _setPressed({required bool value}) {
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => _setPressed(value: true),
      onTapUp: widget.onTap == null ? null : (_) => _setPressed(value: false),
      onTapCancel: widget.onTap == null
          ? null
          : () => _setPressed(value: false),
      onTap: widget.onTap == null
          ? null
          : () {
              if (widget.haptic && Pressable.hapticsEnabled) {
                unawaited(HapticFeedback.lightImpact());
              }
              widget.onTap!();
            },
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _isPressed ? widget.scale : 1,
        duration: AppDurations.resolve(context, AppDurations.fast),
        curve: AppCurves.emphasized,
        child: widget.child,
      ),
    );
  }
}
