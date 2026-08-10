import 'package:app_ui/src/components/buttons/app_icon_button.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:app_ui/src/tokens/app_sizes.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// A pill-shaped search field with a leading search icon and a clear button
/// that appears once text is entered.
class AppSearchField extends StatelessWidget {
  /// Creates an [AppSearchField].
  const AppSearchField({
    required this.controller,
    required this.hintText,
    required this.clearButtonSemanticLabel,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.focusNode,
    super.key,
  });

  /// Controls the field's text.
  final TextEditingController controller;

  /// Placeholder shown when the field is empty.
  final String hintText;

  /// Spoken by screen readers for the clear button.
  final String clearButtonSemanticLabel;

  /// Called on every text change.
  final ValueChanged<String>? onChanged;

  /// Called when the input is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Called after the field is cleared via the clear button.
  final VoidCallback? onClear;

  /// Controls the field's focus.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: AppSizes.iconSmall,
            color: colors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              cursorColor: colors.textPrimary,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textPrimary,
              ),
              textInputAction: TextInputAction.search,
              onTapOutside: (_) => focusNode?.unfocus(),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: AppTypography.rowSubtitle.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              return AnimatedSwitcher(
                duration: AppDurations.fast,
                child: value.text.isNotEmpty
                    ? AppIconButton(
                        key: const ValueKey('clear'),
                        icon: Icons.close_rounded,
                        iconSize: 17,
                        size: 26,
                        color: colors.textSecondary,
                        semanticLabel: clearButtonSemanticLabel,
                        onPressed: () {
                          controller.clear();
                          onClear?.call();
                        },
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              );
            },
          ),
        ],
      ),
    );
  }
}
