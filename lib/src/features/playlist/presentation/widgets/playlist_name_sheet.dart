import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// Shows a sheet asking for a playlist name, returning the trimmed name
/// once confirmed, or `null` if dismissed.
///
/// [initialName] pre-fills the field (renaming); leave it `null` for a new
/// playlist.
Future<String?> showPlaylistNameSheet(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  String? initialName,
}) {
  return AppBottomSheet.show<String>(
    context,
    builder: (sheetContext) => _PlaylistNameSheetContent(
      initialName: initialName,
      title: title,
      confirmLabel: confirmLabel,
    ),
  );
}

class _PlaylistNameSheetContent extends StatefulWidget {
  const _PlaylistNameSheetContent({
    required this.title,
    required this.confirmLabel,
    required this.initialName,
  });

  final String title;
  final String confirmLabel;
  final String? initialName;

  @override
  State<_PlaylistNameSheetContent> createState() =>
      _PlaylistNameSheetContentState();
}

class _PlaylistNameSheetContentState extends State<_PlaylistNameSheetContent> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName,
  );
  late bool _canConfirm = _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: AppTypography.section.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _controller,
              hintText: l10n.playlistNameHint,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onChanged: (value) =>
                  setState(() => _canConfirm = value.trim().isNotEmpty),
              onSubmitted: (_) => _confirm(),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: AppPrimaryButton(
                label: widget.confirmLabel,
                onPressed: _canConfirm ? _confirm : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
