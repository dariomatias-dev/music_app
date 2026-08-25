import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// A track's title/artist/album, as confirmed through
/// [showTrackTagEditSheet].
typedef TrackTagEditResult = ({String title, String artist, String album});

/// Shows a sheet for editing a track's title, artist and album tags,
/// returning the trimmed result once confirmed, or `null` if dismissed.
Future<TrackTagEditResult?> showTrackTagEditSheet(
  BuildContext context, {
  required String initialTitle,
  required String initialArtist,
  required String initialAlbum,
}) {
  return AppBottomSheet.show<TrackTagEditResult>(
    context,
    builder: (sheetContext) => _TrackTagEditSheetContent(
      initialTitle: initialTitle,
      initialArtist: initialArtist,
      initialAlbum: initialAlbum,
    ),
  );
}

class _TrackTagEditSheetContent extends StatefulWidget {
  const _TrackTagEditSheetContent({
    required this.initialTitle,
    required this.initialArtist,
    required this.initialAlbum,
  });

  final String initialTitle;
  final String initialArtist;
  final String initialAlbum;

  @override
  State<_TrackTagEditSheetContent> createState() =>
      _TrackTagEditSheetContentState();
}

class _TrackTagEditSheetContentState extends State<_TrackTagEditSheetContent> {
  late final TextEditingController _titleController = TextEditingController(
    text: widget.initialTitle,
  );
  late final TextEditingController _artistController = TextEditingController(
    text: widget.initialArtist,
  );
  late final TextEditingController _albumController = TextEditingController(
    text: widget.initialAlbum,
  );
  late bool _canConfirm = _titleController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _albumController.dispose();
    super.dispose();
  }

  void _confirm() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    Navigator.of(context).pop((
      title: title,
      artist: _artistController.text.trim(),
      album: _albumController.text.trim(),
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
              l10n.editTagsSheetTitle,
              style: AppTypography.section.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _titleController,
              hintText: l10n.trackTitleHint,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              onChanged: (value) =>
                  setState(() => _canConfirm = value.trim().isNotEmpty),
            ),
            const SizedBox(height: AppSpacing.smMd),
            AppTextField(
              controller: _artistController,
              hintText: l10n.trackArtistHint,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.smMd),
            AppTextField(
              controller: _albumController,
              hintText: l10n.trackAlbumHint,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _confirm(),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: AppPrimaryButton(
                label: l10n.saveLabel,
                onPressed: _canConfirm ? _confirm : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
