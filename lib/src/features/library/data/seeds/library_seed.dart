import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/seed.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

/// Writes the development library: artists, albums and tracks, as a device
/// scan would have left them.
///
/// The catalogue is deliberately uneven. It carries accented names, a name
/// long enough to truncate, an album with no year and no genre, a
/// double-disc album, durations from under two minutes to over nine, and
/// tracks whose files are gone, because a tidy catalogue hides the layout
/// and empty-state problems a seed exists to expose.
class LibrarySeed implements Seed {
  /// Creates a [LibrarySeed] writing into [database], dating the tracks
  /// relative to [clock].
  LibrarySeed(AppDatabase database, {required DateTime Function() clock})
    : _dataSource = LibraryLocalDataSourceImpl(database),
      _clock = clock;

  final LibraryLocalDataSourceImpl _dataSource;
  final DateTime Function() _clock;

  @override
  Future<void> run() async {
    for (final artist in seedArtists) {
      await _dataSource.upsertArtist(artist);
    }
    for (final album in seedAlbums) {
      await _dataSource.upsertAlbum(album);
    }
    for (final track in seedTracksAt(_clock())) {
      await _dataSource.upsertTrack(track);
    }
  }
}

/// The seeded artists, in catalogue order.
List<Artist> get seedArtists => _catalogue.artists;

/// The seeded albums, in catalogue order.
List<Album> get seedAlbums => _catalogue.albums;

/// Ids of the seeded tracks, in catalogue order, for the seeds that
/// reference them.
List<String> get seedTrackIds => [
  for (final track in _catalogue.tracks) track.id,
];

/// The seeded tracks, dated relative to [now].
///
/// The catalogue's last track was added on the day [now] falls, and its
/// first one a few months earlier, so a sort by date has something to
/// order and "recently added" holds something whenever the seed runs.
List<Track> seedTracksAt(DateTime now) {
  final tracks = _catalogue.tracks;
  return [
    for (final (index, track) in tracks.indexed)
      track.copyWith(
        dateAdded: _addedAt(now, index, tracks.length),
        dateModified: _addedAt(now, index, tracks.length),
      ),
  ];
}

DateTime _addedAt(DateTime now, int index, int total) =>
    now.subtract(Duration(days: (total - 1 - index) * 3));

/// One track as the catalogue declares it, before it becomes a [Track].
typedef _TrackSpec = ({
  String title,
  int seconds,
  int disc,
  bool isMissing,
  bool hasArtwork,
});

/// One album as the catalogue declares it, before it becomes an [Album].
typedef _AlbumSpec = ({
  String title,
  int? year,
  String? genre,
  String format,
  List<_TrackSpec> tracks,
});

/// One artist as the catalogue declares it, before it becomes an [Artist].
typedef _ArtistSpec = ({String name, List<_AlbumSpec> albums});

_TrackSpec _track(
  String title,
  int seconds, {
  int disc = 1,
  bool isMissing = false,
  bool hasArtwork = true,
}) => (
  title: title,
  seconds: seconds,
  disc: disc,
  isMissing: isMissing,
  hasArtwork: hasArtwork,
);

_AlbumSpec _album(
  String title, {
  required String format,
  required List<_TrackSpec> tracks,
  int? year,
  String? genre,
}) => (
  title: title,
  year: year,
  genre: genre,
  format: format,
  tracks: tracks,
);

final _specs = <_ArtistSpec>[
  (
    name: 'Charcoal',
    albums: [
      _album(
        'Chill Vibes',
        year: 2019,
        genre: 'Downtempo',
        format: 'mp3',
        tracks: [
          _track('Night Drive', 252),
          _track('Slow Fade', 227),
          _track('Warm Static', 303),
          _track('Glass Hours', 271),
        ],
      ),
      _album(
        'Ember Sessions',
        year: 2021,
        genre: 'Downtempo',
        format: 'flac',
        tracks: [
          _track('Ember Sky', 370),
          _track('Low Tide', 202),
          _track('Paper Moon', 245),
        ],
      ),
    ],
  ),
  (
    name: 'Night Bloom',
    albums: [
      _album(
        'Afterglow',
        year: 2022,
        genre: 'Dream Pop',
        format: 'm4a',
        tracks: [
          _track('Afterglow', 238),
          _track('Petal Static', 284),
          _track('Blue Hour', 326),
          _track('Halflight', 191),
        ],
      ),
      _album(
        'Nocturne',
        format: 'flac',
        tracks: [
          _track('Nocturne I', 458, hasArtwork: false),
          _track('Nocturne II', 532, isMissing: true, hasArtwork: false),
        ],
      ),
    ],
  ),
  (
    name: 'Solar Drift',
    albums: [
      _album(
        'Horizon Line',
        year: 2020,
        genre: 'Ambient',
        format: 'ogg',
        tracks: [
          _track('Horizon Line', 552),
          _track('Dust Parade', 259),
          _track('Signal Lost', 347),
          _track('Meridian', 393),
          _track('Long Way Down', 209),
        ],
      ),
    ],
  ),
  (
    name: 'Íris Fontenele',
    albums: [
      _album(
        'Canções da Maré',
        year: 2023,
        genre: 'MPB',
        format: 'mp3',
        tracks: [
          _track('Maré Cheia', 214),
          _track('Areia Fina', 242),
          _track('Coração de Vidro', 315),
          _track('Vento Sul', 229),
        ],
      ),
      _album(
        'Ao Vivo em São Luís',
        year: 2024,
        genre: 'MPB',
        format: 'mp3',
        tracks: [
          _track('Abertura', 107),
          _track('Maré Cheia (ao vivo)', 268),
          _track('Vento Sul (ao vivo)', 251),
          _track('Chuva de Outubro', 296, disc: 2),
          _track('Areia Fina (ao vivo)', 262, disc: 2),
          _track('Despedida', 344, disc: 2),
        ],
      ),
    ],
  ),
  (
    name: 'The Quietest Possible Orchestra of Very Long Names',
    albums: [
      _album(
        'An Album Title Long Enough to Test How a Row Handles Truncation',
        year: 2018,
        genre: 'Modern Classical',
        format: 'flac',
        tracks: [
          _track('First Movement, Written for an Empty Concert Hall', 486),
          _track('Second Movement, Slower Than the First', 402),
          _track('Third Movement, Barely There at All', 118),
        ],
      ),
    ],
  ),
  (
    name: 'Marceline & the Scream Queens',
    albums: [
      _album(
        'Static Bloom',
        year: 2025,
        genre: 'Noise Pop',
        format: 'mp3',
        tracks: [
          _track('Static Bloom', 197),
          _track('Cassette Teeth', 176),
          _track('Hex Radio', 233, isMissing: true),
          _track('Last Encore', 288),
        ],
      ),
    ],
  ),
];

/// The catalogue as the entities the app stores, built once.
///
/// Identifiers are positional and fixed, so a rerun overwrites the rows it
/// wrote before instead of adding a second copy of the library, and two
/// runs of a screenshot capture produce the same output.
final ({List<Artist> artists, List<Album> albums, List<Track> tracks})
_catalogue = _buildCatalogue();

({List<Artist> artists, List<Album> albums, List<Track> tracks})
_buildCatalogue() {
  final artists = <Artist>[];
  final albums = <Album>[];
  final tracks = <Track>[];

  for (final (artistIndex, artistSpec) in _specs.indexed) {
    final artistId = 'seed-artist-${artistIndex + 1}';
    final artistSourceId = artistSpec.name.trim().toLowerCase();
    var artistTrackCount = 0;

    for (final (albumIndex, albumSpec) in artistSpec.albums.indexed) {
      final albumId = 'seed-album-$artistId-${albumIndex + 1}';
      final albumDuration = albumSpec.tracks.fold(
        Duration.zero,
        (total, track) => total + Duration(seconds: track.seconds),
      );

      albums.add(
        Album(
          id: albumId,
          sourceId: '$artistSourceId::${albumSpec.title.toLowerCase()}',
          title: albumSpec.title,
          artistId: artistId,
          trackCount: albumSpec.tracks.length,
          totalDuration: albumDuration,
          year: albumSpec.year,
        ),
      );

      for (final (trackIndex, trackSpec) in albumSpec.tracks.indexed) {
        final trackId = 'seed-track-${tracks.length + 1}';
        final duration = Duration(seconds: trackSpec.seconds);
        tracks.add(
          Track(
            id: trackId,
            sourceId: trackId,
            filePath: _filePath(artistSpec, albumSpec, trackSpec),
            title: trackSpec.title,
            artistId: artistId,
            albumId: albumId,
            duration: duration,
            format: albumSpec.format,
            fileSize: _fileSize(duration, albumSpec.format),
            hasEmbeddedArtwork: trackSpec.hasArtwork,
            dateAdded: DateTime.fromMillisecondsSinceEpoch(0),
            dateModified: DateTime.fromMillisecondsSinceEpoch(0),
            isMissing: trackSpec.isMissing,
            trackNumber: trackIndex + 1,
            discNumber: trackSpec.disc,
            year: albumSpec.year,
            genre: albumSpec.genre,
            bitrate: _bitrate(albumSpec.format),
            sampleRate: 44100,
          ),
        );
      }

      artistTrackCount += albumSpec.tracks.length;
    }

    artists.add(
      Artist(
        id: artistId,
        sourceId: artistSourceId,
        name: artistSpec.name,
        albumCount: artistSpec.albums.length,
        trackCount: artistTrackCount,
      ),
    );
  }

  return (artists: artists, albums: albums, tracks: tracks);
}

/// A path under a folder per artist and album, so the storage screen has a
/// tree to group and the excluded-folder flows have somewhere to point.
String _filePath(
  _ArtistSpec artist,
  _AlbumSpec album,
  _TrackSpec track,
) {
  final folder = '${_slug(artist.name)}/${_slug(album.title)}';
  return '/storage/emulated/0/Music/$folder/${_slug(track.title)}'
      '.${album.format}';
}

String _slug(String value) => value
    .toLowerCase()
    .replaceAll(RegExp('[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-+|-+$'), '');

int _bitrate(String format) => switch (format) {
  'flac' => 1024000,
  'ogg' => 192000,
  'm4a' => 256000,
  _ => 320000,
};

int _fileSize(Duration duration, String format) =>
    _bitrate(format) ~/ 8 * duration.inSeconds;
