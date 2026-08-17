import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// Shows a sheet asking for the user's display name, returning the trimmed
/// name once confirmed (possibly empty, to clear it), or `null` if
/// dismissed.
Future<String?> showEditNameSheet(
  BuildContext context, {
  required String? initialName,
}) {
  return AppBottomSheet.show<String>(
    context,
    builder: (sheetContext) => _EditNameSheetContent(initialName: initialName),
  );
}

class _EditNameSheetContent extends StatefulWidget {
  const _EditNameSheetContent({required this.initialName});

  final String? initialName;

  @override
  State<_EditNameSheetContent> createState() => _EditNameSheetContentState();
}

class _EditNameSheetContentState extends State<_EditNameSheetContent> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.smMd,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsEditNameSheetTitle,
              style: AppTypography.section.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _controller,
              hintText: l10n.settingsNameHint,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _confirm(),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: AppPrimaryButton(
                label: l10n.saveLabel,
                onPressed: _confirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
