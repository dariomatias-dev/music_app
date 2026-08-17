import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_curves.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:flutter/material.dart';

/// A monochrome on/off switch, styled independently of the platform switch.
class AppSwitch extends StatelessWidget {
  /// Creates an [AppSwitch].
  const AppSwitch({
    required this.value,
    required this.onChanged,
    this.semanticLabel,
    super.key,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value when toggled. When `null`, the switch is
  /// disabled: dimmed and unresponsive to taps.
  final ValueChanged<bool>? onChanged;

  /// Spoken by screen readers.
  final String? semanticLabel;

  static const _width = 46.0;
  static const _height = 28.0;
  static const _thumb = 22.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onChanged != null;

    return Semantics(
      toggled: value,
      enabled: enabled,
      label: semanticLabel,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.4,
        duration: AppDurations.resolve(context, AppDurations.base),
        child: Pressable(
          scale: 0.94,
          onTap: enabled ? () => onChanged!(!value) : null,
          child: AnimatedContainer(
            duration: AppDurations.resolve(context, AppDurations.base),
            curve: AppCurves.emphasized,
            width: _width,
            height: _height,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: value
                  ? colors.accent
                  : colors.textPrimary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: AnimatedAlign(
              duration: AppDurations.resolve(context, AppDurations.base),
              curve: AppCurves.spring,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: _thumb,
                height: _thumb,
                decoration: BoxDecoration(
                  color: value ? colors.onAccent : colors.background,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
