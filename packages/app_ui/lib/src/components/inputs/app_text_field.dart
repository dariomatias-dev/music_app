import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// A text input field, with an optional inline validation error.
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField].
  const AppTextField({
    required this.controller,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    super.key,
  });

  /// Controls the field's text.
  final TextEditingController controller;

  /// Placeholder shown when the field is empty.
  final String? hintText;

  /// Validation message shown below the field. When non-null, the field is
  /// also outlined in the theme's error color.
  final String? errorText;

  /// Called on every text change.
  final ValueChanged<String>? onChanged;

  /// Called when the input is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Controls the field's focus.
  final FocusNode? focusNode;

  /// Whether the field is focused as soon as it is built.
  final bool autofocus;

  /// The type of keyboard to show.
  final TextInputType? keyboardType;

  /// How to capitalize text entered by the user.
  final TextCapitalization textCapitalization;

  /// The keyboard action button to show.
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasError = errorText != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: hasError ? Border.all(color: colors.error) : null,
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            textInputAction: textInputAction,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            cursorColor: colors.textPrimary,
            style: AppTypography.rowTitle.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: hintText,
              hintStyle: AppTypography.rowTitle.copyWith(
                color: colors.textTertiary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Text(
              errorText!,
              style: AppTypography.caption.copyWith(color: colors.error),
            ),
          ),
        ],
      ],
    );
  }
}
