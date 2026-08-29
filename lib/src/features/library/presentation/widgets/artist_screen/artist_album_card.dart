import 'package:flutter/material.dart';
import 'package:music_app/src/core/navigation/navigators/library_navigator.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/presentation/widgets/media_card.dart';

/// One album in the artist screen's horizontal albums strip.
class ArtistAlbumCard extends StatelessWidget {
  /// Creates an [ArtistAlbumCard].
  const ArtistAlbumCard({required this.album, super.key});

  /// The album this card represents.
  final Album album;

  @override
  Widget build(BuildContext context) {
    return MediaCard(
      seed: album.id,
      title: album.title,
      artworkPath: album.artworkPath,
      onTap: () => LibraryNavigator.openAlbum(context, albumId: album.id),
    );
  }
}
