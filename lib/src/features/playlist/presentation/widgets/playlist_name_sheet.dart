import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// A playlist name and optional description, as confirmed through
/// [showPlaylistNameSheet].
typedef PlaylistNameSheetResult = ({String name, String? description});

/// Shows a sheet asking for a playlist name (and, when [showDescriptionField]
/// is `true`, a description), returning the trimmed result once confirmed,
/// or `null` if dismissed.
///
/// [initialName] and [initialDescription] pre-fill the fields (renaming);
/// leave them `null` for a new playlist.
Future<PlaylistNameSheetResult?> showPlaylistNameSheet(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  String? initialName,
  String? initialDescription,
  bool showDescriptionField = false,
}) {
  return AppBottomSheet.show<PlaylistNameSheetResult>(
    context,
    builder: (sheetContext) => _PlaylistNameSheetContent(
      initialName: initialName,
      initialDescription: initialDescription,
      showDescriptionField: showDescriptionField,
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
    required this.initialDescription,
    required this.showDescriptionField,
  });

  final String title;
  final String confirmLabel;
  final String? initialName;
  final String? initialDescription;
  final bool showDescriptionField;

  @override
  State<_PlaylistNameSheetContent> createState() =>
      _PlaylistNameSheetContentState();
}

class _PlaylistNameSheetContentState extends State<_PlaylistNameSheetContent> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initialName,
  );
  late final TextEditingController _descriptionController =
      TextEditingController(text: widget.initialDescription);
  late bool _canConfirm = _nameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _confirm() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final description = _descriptionController.text.trim();
    Navigator.of(context).pop((
      name: name,
      description: description.isEmpty ? null : description,
    ));
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
              controller: _nameController,
              hintText: l10n.playlistNameHint,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: widget.showDescriptionField
                  ? TextInputAction.next
                  : TextInputAction.done,
              onChanged: (value) =>
                  setState(() => _canConfirm = value.trim().isNotEmpty),
              onSubmitted: widget.showDescriptionField
                  ? null
                  : (_) => _confirm(),
            ),
            if (widget.showDescriptionField) ...[
              const SizedBox(height: AppSpacing.smMd),
              AppTextField(
                controller: _descriptionController,
                hintText: l10n.playlistDescriptionHint,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _confirm(),
              ),
            ],
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
