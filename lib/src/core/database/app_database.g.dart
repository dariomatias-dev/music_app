// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ArtistTableTable extends ArtistTable
    with TableInfo<$ArtistTableTable, ArtistRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _albumCountMeta = const VerificationMeta(
    'albumCount',
  );
  @override
  late final GeneratedColumn<int> albumCount = GeneratedColumn<int>(
    'album_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackCountMeta = const VerificationMeta(
    'trackCount',
  );
  @override
  late final GeneratedColumn<int> trackCount = GeneratedColumn<int>(
    'track_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    name,
    albumCount,
    trackCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artist_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArtistRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('album_count')) {
      context.handle(
        _albumCountMeta,
        albumCount.isAcceptableOrUnknown(data['album_count']!, _albumCountMeta),
      );
    } else if (isInserting) {
      context.missing(_albumCountMeta);
    }
    if (data.containsKey('track_count')) {
      context.handle(
        _trackCountMeta,
        trackCount.isAcceptableOrUnknown(data['track_count']!, _trackCountMeta),
      );
    } else if (isInserting) {
      context.missing(_trackCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArtistRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArtistRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      albumCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}album_count'],
      )!,
      trackCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_count'],
      )!,
    );
  }

  @override
  $ArtistTableTable createAlias(String alias) {
    return $ArtistTableTable(attachedDatabase, alias);
  }
}

class ArtistRow extends DataClass implements Insertable<ArtistRow> {
  /// Primary key (UUID v7).
  final String id;

  /// Stable key from the source (MediaStore/filesystem) used to reconcile
  /// re-scans.
  final String sourceId;

  /// Artist name.
  final String name;

  /// Number of albums by this artist.
  final int albumCount;

  /// Number of tracks by this artist.
  final int trackCount;
  const ArtistRow({
    required this.id,
    required this.sourceId,
    required this.name,
    required this.albumCount,
    required this.trackCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['name'] = Variable<String>(name);
    map['album_count'] = Variable<int>(albumCount);
    map['track_count'] = Variable<int>(trackCount);
    return map;
  }

  ArtistTableCompanion toCompanion(bool nullToAbsent) {
    return ArtistTableCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      name: Value(name),
      albumCount: Value(albumCount),
      trackCount: Value(trackCount),
    );
  }

  factory ArtistRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArtistRow(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      name: serializer.fromJson<String>(json['name']),
      albumCount: serializer.fromJson<int>(json['albumCount']),
      trackCount: serializer.fromJson<int>(json['trackCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'name': serializer.toJson<String>(name),
      'albumCount': serializer.toJson<int>(albumCount),
      'trackCount': serializer.toJson<int>(trackCount),
    };
  }

  ArtistRow copyWith({
    String? id,
    String? sourceId,
    String? name,
    int? albumCount,
    int? trackCount,
  }) => ArtistRow(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    name: name ?? this.name,
    albumCount: albumCount ?? this.albumCount,
    trackCount: trackCount ?? this.trackCount,
  );
  ArtistRow copyWithCompanion(ArtistTableCompanion data) {
    return ArtistRow(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      name: data.name.present ? data.name.value : this.name,
      albumCount: data.albumCount.present
          ? data.albumCount.value
          : this.albumCount,
      trackCount: data.trackCount.present
          ? data.trackCount.value
          : this.trackCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArtistRow(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('name: $name, ')
          ..write('albumCount: $albumCount, ')
          ..write('trackCount: $trackCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sourceId, name, albumCount, trackCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArtistRow &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.name == this.name &&
          other.albumCount == this.albumCount &&
          other.trackCount == this.trackCount);
}

class ArtistTableCompanion extends UpdateCompanion<ArtistRow> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> name;
  final Value<int> albumCount;
  final Value<int> trackCount;
  final Value<int> rowid;
  const ArtistTableCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.name = const Value.absent(),
    this.albumCount = const Value.absent(),
    this.trackCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtistTableCompanion.insert({
    required String id,
    required String sourceId,
    required String name,
    required int albumCount,
    required int trackCount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       name = Value(name),
       albumCount = Value(albumCount),
       trackCount = Value(trackCount);
  static Insertable<ArtistRow> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? name,
    Expression<int>? albumCount,
    Expression<int>? trackCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (name != null) 'name': name,
      if (albumCount != null) 'album_count': albumCount,
      if (trackCount != null) 'track_count': trackCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtistTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? name,
    Value<int>? albumCount,
    Value<int>? trackCount,
    Value<int>? rowid,
  }) {
    return ArtistTableCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      name: name ?? this.name,
      albumCount: albumCount ?? this.albumCount,
      trackCount: trackCount ?? this.trackCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (albumCount.present) {
      map['album_count'] = Variable<int>(albumCount.value);
    }
    if (trackCount.present) {
      map['track_count'] = Variable<int>(trackCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('name: $name, ')
          ..write('albumCount: $albumCount, ')
          ..write('trackCount: $trackCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlbumTableTable extends AlbumTable
    with TableInfo<$AlbumTableTable, AlbumRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<String> artistId = GeneratedColumn<String>(
    'artist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES artist_table (id)',
    ),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackCountMeta = const VerificationMeta(
    'trackCount',
  );
  @override
  late final GeneratedColumn<int> trackCount = GeneratedColumn<int>(
    'track_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDurationMeta = const VerificationMeta(
    'totalDuration',
  );
  @override
  late final GeneratedColumn<int> totalDuration = GeneratedColumn<int>(
    'total_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artworkPathMeta = const VerificationMeta(
    'artworkPath',
  );
  @override
  late final GeneratedColumn<String> artworkPath = GeneratedColumn<String>(
    'artwork_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    title,
    artistId,
    year,
    trackCount,
    totalDuration,
    artworkPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'album_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlbumRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('track_count')) {
      context.handle(
        _trackCountMeta,
        trackCount.isAcceptableOrUnknown(data['track_count']!, _trackCountMeta),
      );
    } else if (isInserting) {
      context.missing(_trackCountMeta);
    }
    if (data.containsKey('total_duration')) {
      context.handle(
        _totalDurationMeta,
        totalDuration.isAcceptableOrUnknown(
          data['total_duration']!,
          _totalDurationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalDurationMeta);
    }
    if (data.containsKey('artwork_path')) {
      context.handle(
        _artworkPathMeta,
        artworkPath.isAcceptableOrUnknown(
          data['artwork_path']!,
          _artworkPathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlbumRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      trackCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_count'],
      )!,
      totalDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_duration'],
      )!,
      artworkPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artwork_path'],
      ),
    );
  }

  @override
  $AlbumTableTable createAlias(String alias) {
    return $AlbumTableTable(attachedDatabase, alias);
  }
}

class AlbumRow extends DataClass implements Insertable<AlbumRow> {
  /// Primary key (UUID v7).
  final String id;

  /// Stable key from the source (MediaStore/filesystem) used to reconcile
  /// re-scans.
  final String sourceId;

  /// Album title.
  final String title;

  /// The album's artist.
  final String artistId;

  /// Release year.
  final int? year;

  /// Number of tracks in the album.
  final int trackCount;

  /// Total duration, in milliseconds.
  final int totalDuration;

  /// Path to the cached artwork, if any.
  final String? artworkPath;
  const AlbumRow({
    required this.id,
    required this.sourceId,
    required this.title,
    required this.artistId,
    this.year,
    required this.trackCount,
    required this.totalDuration,
    this.artworkPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['title'] = Variable<String>(title);
    map['artist_id'] = Variable<String>(artistId);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    map['track_count'] = Variable<int>(trackCount);
    map['total_duration'] = Variable<int>(totalDuration);
    if (!nullToAbsent || artworkPath != null) {
      map['artwork_path'] = Variable<String>(artworkPath);
    }
    return map;
  }

  AlbumTableCompanion toCompanion(bool nullToAbsent) {
    return AlbumTableCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      title: Value(title),
      artistId: Value(artistId),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      trackCount: Value(trackCount),
      totalDuration: Value(totalDuration),
      artworkPath: artworkPath == null && nullToAbsent
          ? const Value.absent()
          : Value(artworkPath),
    );
  }

  factory AlbumRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumRow(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      title: serializer.fromJson<String>(json['title']),
      artistId: serializer.fromJson<String>(json['artistId']),
      year: serializer.fromJson<int?>(json['year']),
      trackCount: serializer.fromJson<int>(json['trackCount']),
      totalDuration: serializer.fromJson<int>(json['totalDuration']),
      artworkPath: serializer.fromJson<String?>(json['artworkPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'title': serializer.toJson<String>(title),
      'artistId': serializer.toJson<String>(artistId),
      'year': serializer.toJson<int?>(year),
      'trackCount': serializer.toJson<int>(trackCount),
      'totalDuration': serializer.toJson<int>(totalDuration),
      'artworkPath': serializer.toJson<String?>(artworkPath),
    };
  }

  AlbumRow copyWith({
    String? id,
    String? sourceId,
    String? title,
    String? artistId,
    Value<int?> year = const Value.absent(),
    int? trackCount,
    int? totalDuration,
    Value<String?> artworkPath = const Value.absent(),
  }) => AlbumRow(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    title: title ?? this.title,
    artistId: artistId ?? this.artistId,
    year: year.present ? year.value : this.year,
    trackCount: trackCount ?? this.trackCount,
    totalDuration: totalDuration ?? this.totalDuration,
    artworkPath: artworkPath.present ? artworkPath.value : this.artworkPath,
  );
  AlbumRow copyWithCompanion(AlbumTableCompanion data) {
    return AlbumRow(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      title: data.title.present ? data.title.value : this.title,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      year: data.year.present ? data.year.value : this.year,
      trackCount: data.trackCount.present
          ? data.trackCount.value
          : this.trackCount,
      totalDuration: data.totalDuration.present
          ? data.totalDuration.value
          : this.totalDuration,
      artworkPath: data.artworkPath.present
          ? data.artworkPath.value
          : this.artworkPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlbumRow(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('artistId: $artistId, ')
          ..write('year: $year, ')
          ..write('trackCount: $trackCount, ')
          ..write('totalDuration: $totalDuration, ')
          ..write('artworkPath: $artworkPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    title,
    artistId,
    year,
    trackCount,
    totalDuration,
    artworkPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumRow &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.title == this.title &&
          other.artistId == this.artistId &&
          other.year == this.year &&
          other.trackCount == this.trackCount &&
          other.totalDuration == this.totalDuration &&
          other.artworkPath == this.artworkPath);
}

class AlbumTableCompanion extends UpdateCompanion<AlbumRow> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> title;
  final Value<String> artistId;
  final Value<int?> year;
  final Value<int> trackCount;
  final Value<int> totalDuration;
  final Value<String?> artworkPath;
  final Value<int> rowid;
  const AlbumTableCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.title = const Value.absent(),
    this.artistId = const Value.absent(),
    this.year = const Value.absent(),
    this.trackCount = const Value.absent(),
    this.totalDuration = const Value.absent(),
    this.artworkPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumTableCompanion.insert({
    required String id,
    required String sourceId,
    required String title,
    required String artistId,
    this.year = const Value.absent(),
    required int trackCount,
    required int totalDuration,
    this.artworkPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       title = Value(title),
       artistId = Value(artistId),
       trackCount = Value(trackCount),
       totalDuration = Value(totalDuration);
  static Insertable<AlbumRow> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? title,
    Expression<String>? artistId,
    Expression<int>? year,
    Expression<int>? trackCount,
    Expression<int>? totalDuration,
    Expression<String>? artworkPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (title != null) 'title': title,
      if (artistId != null) 'artist_id': artistId,
      if (year != null) 'year': year,
      if (trackCount != null) 'track_count': trackCount,
      if (totalDuration != null) 'total_duration': totalDuration,
      if (artworkPath != null) 'artwork_path': artworkPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? title,
    Value<String>? artistId,
    Value<int?>? year,
    Value<int>? trackCount,
    Value<int>? totalDuration,
    Value<String?>? artworkPath,
    Value<int>? rowid,
  }) {
    return AlbumTableCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      year: year ?? this.year,
      trackCount: trackCount ?? this.trackCount,
      totalDuration: totalDuration ?? this.totalDuration,
      artworkPath: artworkPath ?? this.artworkPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<String>(artistId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (trackCount.present) {
      map['track_count'] = Variable<int>(trackCount.value);
    }
    if (totalDuration.present) {
      map['total_duration'] = Variable<int>(totalDuration.value);
    }
    if (artworkPath.present) {
      map['artwork_path'] = Variable<String>(artworkPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('artistId: $artistId, ')
          ..write('year: $year, ')
          ..write('trackCount: $trackCount, ')
          ..write('totalDuration: $totalDuration, ')
          ..write('artworkPath: $artworkPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackTableTable extends TrackTable
    with TableInfo<$TrackTableTable, TrackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<String> artistId = GeneratedColumn<String>(
    'artist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES artist_table (id)',
    ),
  );
  static const VerificationMeta _albumIdMeta = const VerificationMeta(
    'albumId',
  );
  @override
  late final GeneratedColumn<String> albumId = GeneratedColumn<String>(
    'album_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES album_table (id)',
    ),
  );
  static const VerificationMeta _trackNumberMeta = const VerificationMeta(
    'trackNumber',
  );
  @override
  late final GeneratedColumn<int> trackNumber = GeneratedColumn<int>(
    'track_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discNumberMeta = const VerificationMeta(
    'discNumber',
  );
  @override
  late final GeneratedColumn<int> discNumber = GeneratedColumn<int>(
    'disc_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bitrateMeta = const VerificationMeta(
    'bitrate',
  );
  @override
  late final GeneratedColumn<int> bitrate = GeneratedColumn<int>(
    'bitrate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sampleRateMeta = const VerificationMeta(
    'sampleRate',
  );
  @override
  late final GeneratedColumn<int> sampleRate = GeneratedColumn<int>(
    'sample_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasEmbeddedArtworkMeta =
      const VerificationMeta('hasEmbeddedArtwork');
  @override
  late final GeneratedColumn<bool> hasEmbeddedArtwork = GeneratedColumn<bool>(
    'has_embedded_artwork',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_embedded_artwork" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isMissingMeta = const VerificationMeta(
    'isMissing',
  );
  @override
  late final GeneratedColumn<bool> isMissing = GeneratedColumn<bool>(
    'is_missing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_missing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateModifiedMeta = const VerificationMeta(
    'dateModified',
  );
  @override
  late final GeneratedColumn<DateTime> dateModified = GeneratedColumn<DateTime>(
    'date_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    filePath,
    title,
    artistId,
    albumId,
    trackNumber,
    discNumber,
    duration,
    year,
    genre,
    bitrate,
    sampleRate,
    format,
    fileSize,
    hasEmbeddedArtwork,
    isMissing,
    dateAdded,
    dateModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    if (data.containsKey('album_id')) {
      context.handle(
        _albumIdMeta,
        albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta),
      );
    } else if (isInserting) {
      context.missing(_albumIdMeta);
    }
    if (data.containsKey('track_number')) {
      context.handle(
        _trackNumberMeta,
        trackNumber.isAcceptableOrUnknown(
          data['track_number']!,
          _trackNumberMeta,
        ),
      );
    }
    if (data.containsKey('disc_number')) {
      context.handle(
        _discNumberMeta,
        discNumber.isAcceptableOrUnknown(data['disc_number']!, _discNumberMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('bitrate')) {
      context.handle(
        _bitrateMeta,
        bitrate.isAcceptableOrUnknown(data['bitrate']!, _bitrateMeta),
      );
    }
    if (data.containsKey('sample_rate')) {
      context.handle(
        _sampleRateMeta,
        sampleRate.isAcceptableOrUnknown(data['sample_rate']!, _sampleRateMeta),
      );
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('has_embedded_artwork')) {
      context.handle(
        _hasEmbeddedArtworkMeta,
        hasEmbeddedArtwork.isAcceptableOrUnknown(
          data['has_embedded_artwork']!,
          _hasEmbeddedArtworkMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasEmbeddedArtworkMeta);
    }
    if (data.containsKey('is_missing')) {
      context.handle(
        _isMissingMeta,
        isMissing.isAcceptableOrUnknown(data['is_missing']!, _isMissingMeta),
      );
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    if (data.containsKey('date_modified')) {
      context.handle(
        _dateModifiedMeta,
        dateModified.isAcceptableOrUnknown(
          data['date_modified']!,
          _dateModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateModifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_id'],
      )!,
      albumId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_id'],
      )!,
      trackNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_number'],
      ),
      discNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disc_number'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      bitrate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bitrate'],
      ),
      sampleRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sample_rate'],
      ),
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      hasEmbeddedArtwork: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_embedded_artwork'],
      )!,
      isMissing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_missing'],
      )!,
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_added'],
      )!,
      dateModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_modified'],
      )!,
    );
  }

  @override
  $TrackTableTable createAlias(String alias) {
    return $TrackTableTable(attachedDatabase, alias);
  }
}

class TrackRow extends DataClass implements Insertable<TrackRow> {
  /// Primary key (UUID v7).
  final String id;

  /// Stable key from the source (MediaStore/filesystem) used to reconcile
  /// re-scans.
  final String sourceId;

  /// Path to the audio file on disk.
  final String filePath;

  /// Track title.
  final String title;

  /// The track's artist.
  final String artistId;

  /// The track's album.
  final String albumId;

  /// Position within the album, if known.
  final int? trackNumber;

  /// Disc number within the album, if known.
  final int? discNumber;

  /// Duration, in milliseconds.
  final int duration;

  /// Release year, if known.
  final int? year;

  /// Genre, if known.
  final String? genre;

  /// Bitrate, in bits per second, if known.
  final int? bitrate;

  /// Sample rate, in Hz, if known.
  final int? sampleRate;

  /// File format (e.g. mp3, flac).
  final String format;

  /// File size, in bytes.
  final int fileSize;

  /// Whether the file has an embedded artwork image.
  final bool hasEmbeddedArtwork;

  /// Whether the file was not found by the most recent scan.
  final bool isMissing;

  /// When the track was added to the library.
  final DateTime dateAdded;

  /// When the file was last modified.
  final DateTime dateModified;
  const TrackRow({
    required this.id,
    required this.sourceId,
    required this.filePath,
    required this.title,
    required this.artistId,
    required this.albumId,
    this.trackNumber,
    this.discNumber,
    required this.duration,
    this.year,
    this.genre,
    this.bitrate,
    this.sampleRate,
    required this.format,
    required this.fileSize,
    required this.hasEmbeddedArtwork,
    required this.isMissing,
    required this.dateAdded,
    required this.dateModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['file_path'] = Variable<String>(filePath);
    map['title'] = Variable<String>(title);
    map['artist_id'] = Variable<String>(artistId);
    map['album_id'] = Variable<String>(albumId);
    if (!nullToAbsent || trackNumber != null) {
      map['track_number'] = Variable<int>(trackNumber);
    }
    if (!nullToAbsent || discNumber != null) {
      map['disc_number'] = Variable<int>(discNumber);
    }
    map['duration'] = Variable<int>(duration);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || bitrate != null) {
      map['bitrate'] = Variable<int>(bitrate);
    }
    if (!nullToAbsent || sampleRate != null) {
      map['sample_rate'] = Variable<int>(sampleRate);
    }
    map['format'] = Variable<String>(format);
    map['file_size'] = Variable<int>(fileSize);
    map['has_embedded_artwork'] = Variable<bool>(hasEmbeddedArtwork);
    map['is_missing'] = Variable<bool>(isMissing);
    map['date_added'] = Variable<DateTime>(dateAdded);
    map['date_modified'] = Variable<DateTime>(dateModified);
    return map;
  }

  TrackTableCompanion toCompanion(bool nullToAbsent) {
    return TrackTableCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      filePath: Value(filePath),
      title: Value(title),
      artistId: Value(artistId),
      albumId: Value(albumId),
      trackNumber: trackNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(trackNumber),
      discNumber: discNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(discNumber),
      duration: Value(duration),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      bitrate: bitrate == null && nullToAbsent
          ? const Value.absent()
          : Value(bitrate),
      sampleRate: sampleRate == null && nullToAbsent
          ? const Value.absent()
          : Value(sampleRate),
      format: Value(format),
      fileSize: Value(fileSize),
      hasEmbeddedArtwork: Value(hasEmbeddedArtwork),
      isMissing: Value(isMissing),
      dateAdded: Value(dateAdded),
      dateModified: Value(dateModified),
    );
  }

  factory TrackRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackRow(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      title: serializer.fromJson<String>(json['title']),
      artistId: serializer.fromJson<String>(json['artistId']),
      albumId: serializer.fromJson<String>(json['albumId']),
      trackNumber: serializer.fromJson<int?>(json['trackNumber']),
      discNumber: serializer.fromJson<int?>(json['discNumber']),
      duration: serializer.fromJson<int>(json['duration']),
      year: serializer.fromJson<int?>(json['year']),
      genre: serializer.fromJson<String?>(json['genre']),
      bitrate: serializer.fromJson<int?>(json['bitrate']),
      sampleRate: serializer.fromJson<int?>(json['sampleRate']),
      format: serializer.fromJson<String>(json['format']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      hasEmbeddedArtwork: serializer.fromJson<bool>(json['hasEmbeddedArtwork']),
      isMissing: serializer.fromJson<bool>(json['isMissing']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      dateModified: serializer.fromJson<DateTime>(json['dateModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'filePath': serializer.toJson<String>(filePath),
      'title': serializer.toJson<String>(title),
      'artistId': serializer.toJson<String>(artistId),
      'albumId': serializer.toJson<String>(albumId),
      'trackNumber': serializer.toJson<int?>(trackNumber),
      'discNumber': serializer.toJson<int?>(discNumber),
      'duration': serializer.toJson<int>(duration),
      'year': serializer.toJson<int?>(year),
      'genre': serializer.toJson<String?>(genre),
      'bitrate': serializer.toJson<int?>(bitrate),
      'sampleRate': serializer.toJson<int?>(sampleRate),
      'format': serializer.toJson<String>(format),
      'fileSize': serializer.toJson<int>(fileSize),
      'hasEmbeddedArtwork': serializer.toJson<bool>(hasEmbeddedArtwork),
      'isMissing': serializer.toJson<bool>(isMissing),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'dateModified': serializer.toJson<DateTime>(dateModified),
    };
  }

  TrackRow copyWith({
    String? id,
    String? sourceId,
    String? filePath,
    String? title,
    String? artistId,
    String? albumId,
    Value<int?> trackNumber = const Value.absent(),
    Value<int?> discNumber = const Value.absent(),
    int? duration,
    Value<int?> year = const Value.absent(),
    Value<String?> genre = const Value.absent(),
    Value<int?> bitrate = const Value.absent(),
    Value<int?> sampleRate = const Value.absent(),
    String? format,
    int? fileSize,
    bool? hasEmbeddedArtwork,
    bool? isMissing,
    DateTime? dateAdded,
    DateTime? dateModified,
  }) => TrackRow(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    filePath: filePath ?? this.filePath,
    title: title ?? this.title,
    artistId: artistId ?? this.artistId,
    albumId: albumId ?? this.albumId,
    trackNumber: trackNumber.present ? trackNumber.value : this.trackNumber,
    discNumber: discNumber.present ? discNumber.value : this.discNumber,
    duration: duration ?? this.duration,
    year: year.present ? year.value : this.year,
    genre: genre.present ? genre.value : this.genre,
    bitrate: bitrate.present ? bitrate.value : this.bitrate,
    sampleRate: sampleRate.present ? sampleRate.value : this.sampleRate,
    format: format ?? this.format,
    fileSize: fileSize ?? this.fileSize,
    hasEmbeddedArtwork: hasEmbeddedArtwork ?? this.hasEmbeddedArtwork,
    isMissing: isMissing ?? this.isMissing,
    dateAdded: dateAdded ?? this.dateAdded,
    dateModified: dateModified ?? this.dateModified,
  );
  TrackRow copyWithCompanion(TrackTableCompanion data) {
    return TrackRow(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      title: data.title.present ? data.title.value : this.title,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      trackNumber: data.trackNumber.present
          ? data.trackNumber.value
          : this.trackNumber,
      discNumber: data.discNumber.present
          ? data.discNumber.value
          : this.discNumber,
      duration: data.duration.present ? data.duration.value : this.duration,
      year: data.year.present ? data.year.value : this.year,
      genre: data.genre.present ? data.genre.value : this.genre,
      bitrate: data.bitrate.present ? data.bitrate.value : this.bitrate,
      sampleRate: data.sampleRate.present
          ? data.sampleRate.value
          : this.sampleRate,
      format: data.format.present ? data.format.value : this.format,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      hasEmbeddedArtwork: data.hasEmbeddedArtwork.present
          ? data.hasEmbeddedArtwork.value
          : this.hasEmbeddedArtwork,
      isMissing: data.isMissing.present ? data.isMissing.value : this.isMissing,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      dateModified: data.dateModified.present
          ? data.dateModified.value
          : this.dateModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackRow(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('filePath: $filePath, ')
          ..write('title: $title, ')
          ..write('artistId: $artistId, ')
          ..write('albumId: $albumId, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('discNumber: $discNumber, ')
          ..write('duration: $duration, ')
          ..write('year: $year, ')
          ..write('genre: $genre, ')
          ..write('bitrate: $bitrate, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('format: $format, ')
          ..write('fileSize: $fileSize, ')
          ..write('hasEmbeddedArtwork: $hasEmbeddedArtwork, ')
          ..write('isMissing: $isMissing, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('dateModified: $dateModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    filePath,
    title,
    artistId,
    albumId,
    trackNumber,
    discNumber,
    duration,
    year,
    genre,
    bitrate,
    sampleRate,
    format,
    fileSize,
    hasEmbeddedArtwork,
    isMissing,
    dateAdded,
    dateModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackRow &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.filePath == this.filePath &&
          other.title == this.title &&
          other.artistId == this.artistId &&
          other.albumId == this.albumId &&
          other.trackNumber == this.trackNumber &&
          other.discNumber == this.discNumber &&
          other.duration == this.duration &&
          other.year == this.year &&
          other.genre == this.genre &&
          other.bitrate == this.bitrate &&
          other.sampleRate == this.sampleRate &&
          other.format == this.format &&
          other.fileSize == this.fileSize &&
          other.hasEmbeddedArtwork == this.hasEmbeddedArtwork &&
          other.isMissing == this.isMissing &&
          other.dateAdded == this.dateAdded &&
          other.dateModified == this.dateModified);
}

class TrackTableCompanion extends UpdateCompanion<TrackRow> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> filePath;
  final Value<String> title;
  final Value<String> artistId;
  final Value<String> albumId;
  final Value<int?> trackNumber;
  final Value<int?> discNumber;
  final Value<int> duration;
  final Value<int?> year;
  final Value<String?> genre;
  final Value<int?> bitrate;
  final Value<int?> sampleRate;
  final Value<String> format;
  final Value<int> fileSize;
  final Value<bool> hasEmbeddedArtwork;
  final Value<bool> isMissing;
  final Value<DateTime> dateAdded;
  final Value<DateTime> dateModified;
  final Value<int> rowid;
  const TrackTableCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.title = const Value.absent(),
    this.artistId = const Value.absent(),
    this.albumId = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.discNumber = const Value.absent(),
    this.duration = const Value.absent(),
    this.year = const Value.absent(),
    this.genre = const Value.absent(),
    this.bitrate = const Value.absent(),
    this.sampleRate = const Value.absent(),
    this.format = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.hasEmbeddedArtwork = const Value.absent(),
    this.isMissing = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.dateModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackTableCompanion.insert({
    required String id,
    required String sourceId,
    required String filePath,
    required String title,
    required String artistId,
    required String albumId,
    this.trackNumber = const Value.absent(),
    this.discNumber = const Value.absent(),
    required int duration,
    this.year = const Value.absent(),
    this.genre = const Value.absent(),
    this.bitrate = const Value.absent(),
    this.sampleRate = const Value.absent(),
    required String format,
    required int fileSize,
    required bool hasEmbeddedArtwork,
    this.isMissing = const Value.absent(),
    required DateTime dateAdded,
    required DateTime dateModified,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       filePath = Value(filePath),
       title = Value(title),
       artistId = Value(artistId),
       albumId = Value(albumId),
       duration = Value(duration),
       format = Value(format),
       fileSize = Value(fileSize),
       hasEmbeddedArtwork = Value(hasEmbeddedArtwork),
       dateAdded = Value(dateAdded),
       dateModified = Value(dateModified);
  static Insertable<TrackRow> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? filePath,
    Expression<String>? title,
    Expression<String>? artistId,
    Expression<String>? albumId,
    Expression<int>? trackNumber,
    Expression<int>? discNumber,
    Expression<int>? duration,
    Expression<int>? year,
    Expression<String>? genre,
    Expression<int>? bitrate,
    Expression<int>? sampleRate,
    Expression<String>? format,
    Expression<int>? fileSize,
    Expression<bool>? hasEmbeddedArtwork,
    Expression<bool>? isMissing,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? dateModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (filePath != null) 'file_path': filePath,
      if (title != null) 'title': title,
      if (artistId != null) 'artist_id': artistId,
      if (albumId != null) 'album_id': albumId,
      if (trackNumber != null) 'track_number': trackNumber,
      if (discNumber != null) 'disc_number': discNumber,
      if (duration != null) 'duration': duration,
      if (year != null) 'year': year,
      if (genre != null) 'genre': genre,
      if (bitrate != null) 'bitrate': bitrate,
      if (sampleRate != null) 'sample_rate': sampleRate,
      if (format != null) 'format': format,
      if (fileSize != null) 'file_size': fileSize,
      if (hasEmbeddedArtwork != null)
        'has_embedded_artwork': hasEmbeddedArtwork,
      if (isMissing != null) 'is_missing': isMissing,
      if (dateAdded != null) 'date_added': dateAdded,
      if (dateModified != null) 'date_modified': dateModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? filePath,
    Value<String>? title,
    Value<String>? artistId,
    Value<String>? albumId,
    Value<int?>? trackNumber,
    Value<int?>? discNumber,
    Value<int>? duration,
    Value<int?>? year,
    Value<String?>? genre,
    Value<int?>? bitrate,
    Value<int?>? sampleRate,
    Value<String>? format,
    Value<int>? fileSize,
    Value<bool>? hasEmbeddedArtwork,
    Value<bool>? isMissing,
    Value<DateTime>? dateAdded,
    Value<DateTime>? dateModified,
    Value<int>? rowid,
  }) {
    return TrackTableCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      filePath: filePath ?? this.filePath,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      albumId: albumId ?? this.albumId,
      trackNumber: trackNumber ?? this.trackNumber,
      discNumber: discNumber ?? this.discNumber,
      duration: duration ?? this.duration,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      bitrate: bitrate ?? this.bitrate,
      sampleRate: sampleRate ?? this.sampleRate,
      format: format ?? this.format,
      fileSize: fileSize ?? this.fileSize,
      hasEmbeddedArtwork: hasEmbeddedArtwork ?? this.hasEmbeddedArtwork,
      isMissing: isMissing ?? this.isMissing,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<String>(artistId.value);
    }
    if (albumId.present) {
      map['album_id'] = Variable<String>(albumId.value);
    }
    if (trackNumber.present) {
      map['track_number'] = Variable<int>(trackNumber.value);
    }
    if (discNumber.present) {
      map['disc_number'] = Variable<int>(discNumber.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (bitrate.present) {
      map['bitrate'] = Variable<int>(bitrate.value);
    }
    if (sampleRate.present) {
      map['sample_rate'] = Variable<int>(sampleRate.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (hasEmbeddedArtwork.present) {
      map['has_embedded_artwork'] = Variable<bool>(hasEmbeddedArtwork.value);
    }
    if (isMissing.present) {
      map['is_missing'] = Variable<bool>(isMissing.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (dateModified.present) {
      map['date_modified'] = Variable<DateTime>(dateModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('filePath: $filePath, ')
          ..write('title: $title, ')
          ..write('artistId: $artistId, ')
          ..write('albumId: $albumId, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('discNumber: $discNumber, ')
          ..write('duration: $duration, ')
          ..write('year: $year, ')
          ..write('genre: $genre, ')
          ..write('bitrate: $bitrate, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('format: $format, ')
          ..write('fileSize: $fileSize, ')
          ..write('hasEmbeddedArtwork: $hasEmbeddedArtwork, ')
          ..write('isMissing: $isMissing, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('dateModified: $dateModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistTableTable extends PlaylistTable
    with TableInfo<$PlaylistTableTable, PlaylistRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoritesPlaylistMeta =
      const VerificationMeta('isFavoritesPlaylist');
  @override
  late final GeneratedColumn<bool> isFavoritesPlaylist = GeneratedColumn<bool>(
    'is_favorites_playlist',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorites_playlist" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    isFavorite,
    isFavoritesPlaylist,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaylistRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_favorites_playlist')) {
      context.handle(
        _isFavoritesPlaylistMeta,
        isFavoritesPlaylist.isAcceptableOrUnknown(
          data['is_favorites_playlist']!,
          _isFavoritesPlaylistMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isFavoritesPlaylist: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorites_playlist'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlaylistTableTable createAlias(String alias) {
    return $PlaylistTableTable(attachedDatabase, alias);
  }
}

class PlaylistRow extends DataClass implements Insertable<PlaylistRow> {
  /// Primary key (UUID v7).
  final String id;

  /// Playlist name.
  final String name;

  /// Optional description shown under the playlist's title.
  final String? description;

  /// Whether the user has favorited this playlist.
  final bool isFavorite;

  /// Whether this is the built-in favorites playlist.
  final bool isFavoritesPlaylist;

  /// When the playlist was created.
  final DateTime createdAt;

  /// When the playlist was last updated.
  final DateTime updatedAt;
  const PlaylistRow({
    required this.id,
    required this.name,
    this.description,
    required this.isFavorite,
    required this.isFavoritesPlaylist,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_favorites_playlist'] = Variable<bool>(isFavoritesPlaylist);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlaylistTableCompanion toCompanion(bool nullToAbsent) {
    return PlaylistTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isFavorite: Value(isFavorite),
      isFavoritesPlaylist: Value(isFavoritesPlaylist),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlaylistRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isFavoritesPlaylist: serializer.fromJson<bool>(
        json['isFavoritesPlaylist'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isFavoritesPlaylist': serializer.toJson<bool>(isFavoritesPlaylist),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlaylistRow copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? isFavorite,
    bool? isFavoritesPlaylist,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PlaylistRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    isFavorite: isFavorite ?? this.isFavorite,
    isFavoritesPlaylist: isFavoritesPlaylist ?? this.isFavoritesPlaylist,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlaylistRow copyWithCompanion(PlaylistTableCompanion data) {
    return PlaylistRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      isFavoritesPlaylist: data.isFavoritesPlaylist.present
          ? data.isFavoritesPlaylist.value
          : this.isFavoritesPlaylist,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isFavoritesPlaylist: $isFavoritesPlaylist, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    isFavorite,
    isFavoritesPlaylist,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.isFavorite == this.isFavorite &&
          other.isFavoritesPlaylist == this.isFavoritesPlaylist &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlaylistTableCompanion extends UpdateCompanion<PlaylistRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> isFavorite;
  final Value<bool> isFavoritesPlaylist;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlaylistTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isFavoritesPlaylist = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistTableCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isFavoritesPlaylist = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PlaylistRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? isFavorite,
    Expression<bool>? isFavoritesPlaylist,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isFavoritesPlaylist != null)
        'is_favorites_playlist': isFavoritesPlaylist,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? isFavorite,
    Value<bool>? isFavoritesPlaylist,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlaylistTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      isFavoritesPlaylist: isFavoritesPlaylist ?? this.isFavoritesPlaylist,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isFavoritesPlaylist.present) {
      map['is_favorites_playlist'] = Variable<bool>(isFavoritesPlaylist.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isFavoritesPlaylist: $isFavoritesPlaylist, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistTrackTableTable extends PlaylistTrackTable
    with TableInfo<$PlaylistTrackTableTable, PlaylistTrackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistTrackTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<String> playlistId = GeneratedColumn<String>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES playlist_table (id)',
    ),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES track_table (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, playlistId, trackId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_track_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaylistTrackRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistTrackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistTrackRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}playlist_id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $PlaylistTrackTableTable createAlias(String alias) {
    return $PlaylistTrackTableTable(attachedDatabase, alias);
  }
}

class PlaylistTrackRow extends DataClass
    implements Insertable<PlaylistTrackRow> {
  /// Primary key.
  final int id;

  /// The playlist this entry belongs to.
  final String playlistId;

  /// The referenced track.
  final String trackId;

  /// Position of the track within the playlist.
  final int position;
  const PlaylistTrackRow({
    required this.id,
    required this.playlistId,
    required this.trackId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_id'] = Variable<String>(playlistId);
    map['track_id'] = Variable<String>(trackId);
    map['position'] = Variable<int>(position);
    return map;
  }

  PlaylistTrackTableCompanion toCompanion(bool nullToAbsent) {
    return PlaylistTrackTableCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      trackId: Value(trackId),
      position: Value(position),
    );
  }

  factory PlaylistTrackRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistTrackRow(
      id: serializer.fromJson<int>(json['id']),
      playlistId: serializer.fromJson<String>(json['playlistId']),
      trackId: serializer.fromJson<String>(json['trackId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<String>(playlistId),
      'trackId': serializer.toJson<String>(trackId),
      'position': serializer.toJson<int>(position),
    };
  }

  PlaylistTrackRow copyWith({
    int? id,
    String? playlistId,
    String? trackId,
    int? position,
  }) => PlaylistTrackRow(
    id: id ?? this.id,
    playlistId: playlistId ?? this.playlistId,
    trackId: trackId ?? this.trackId,
    position: position ?? this.position,
  );
  PlaylistTrackRow copyWithCompanion(PlaylistTrackTableCompanion data) {
    return PlaylistTrackRow(
      id: data.id.present ? data.id.value : this.id,
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTrackRow(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playlistId, trackId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistTrackRow &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.trackId == this.trackId &&
          other.position == this.position);
}

class PlaylistTrackTableCompanion extends UpdateCompanion<PlaylistTrackRow> {
  final Value<int> id;
  final Value<String> playlistId;
  final Value<String> trackId;
  final Value<int> position;
  const PlaylistTrackTableCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.trackId = const Value.absent(),
    this.position = const Value.absent(),
  });
  PlaylistTrackTableCompanion.insert({
    this.id = const Value.absent(),
    required String playlistId,
    required String trackId,
    required int position,
  }) : playlistId = Value(playlistId),
       trackId = Value(trackId),
       position = Value(position);
  static Insertable<PlaylistTrackRow> custom({
    Expression<int>? id,
    Expression<String>? playlistId,
    Expression<String>? trackId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (trackId != null) 'track_id': trackId,
      if (position != null) 'position': position,
    });
  }

  PlaylistTrackTableCompanion copyWith({
    Value<int>? id,
    Value<String>? playlistId,
    Value<String>? trackId,
    Value<int>? position,
  }) {
    return PlaylistTrackTableCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      trackId: trackId ?? this.trackId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<String>(playlistId.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTrackTableCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $FavoriteTableTable extends FavoriteTable
    with TableInfo<$FavoriteTableTable, FavoriteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES track_table (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, trackId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {trackId},
  ];
  @override
  FavoriteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FavoriteTableTable createAlias(String alias) {
    return $FavoriteTableTable(attachedDatabase, alias);
  }
}

class FavoriteRow extends DataClass implements Insertable<FavoriteRow> {
  /// Primary key (UUID v7).
  final String id;

  /// The favorited track.
  final String trackId;

  /// When the track was favorited.
  final DateTime createdAt;
  const FavoriteRow({
    required this.id,
    required this.trackId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['track_id'] = Variable<String>(trackId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoriteTableCompanion toCompanion(bool nullToAbsent) {
    return FavoriteTableCompanion(
      id: Value(id),
      trackId: Value(trackId),
      createdAt: Value(createdAt),
    );
  }

  factory FavoriteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteRow(
      id: serializer.fromJson<String>(json['id']),
      trackId: serializer.fromJson<String>(json['trackId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackId': serializer.toJson<String>(trackId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoriteRow copyWith({String? id, String? trackId, DateTime? createdAt}) =>
      FavoriteRow(
        id: id ?? this.id,
        trackId: trackId ?? this.trackId,
        createdAt: createdAt ?? this.createdAt,
      );
  FavoriteRow copyWithCompanion(FavoriteTableCompanion data) {
    return FavoriteRow(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRow(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteRow &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.createdAt == this.createdAt);
}

class FavoriteTableCompanion extends UpdateCompanion<FavoriteRow> {
  final Value<String> id;
  final Value<String> trackId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FavoriteTableCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteTableCompanion.insert({
    required String id,
    required String trackId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trackId = Value(trackId),
       createdAt = Value(createdAt);
  static Insertable<FavoriteRow> custom({
    Expression<String>? id,
    Expression<String>? trackId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteTableCompanion copyWith({
    Value<String>? id,
    Value<String>? trackId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FavoriteTableCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteTableCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayEventTableTable extends PlayEventTable
    with TableInfo<$PlayEventTableTable, PlayEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayEventTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES track_table (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playedDurationMeta = const VerificationMeta(
    'playedDuration',
  );
  @override
  late final GeneratedColumn<int> playedDuration = GeneratedColumn<int>(
    'played_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackId,
    startedAt,
    playedDuration,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'play_event_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('played_duration')) {
      context.handle(
        _playedDurationMeta,
        playedDuration.isAcceptableOrUnknown(
          data['played_duration']!,
          _playedDurationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_playedDurationMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      playedDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}played_duration'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $PlayEventTableTable createAlias(String alias) {
    return $PlayEventTableTable(attachedDatabase, alias);
  }
}

class PlayEventRow extends DataClass implements Insertable<PlayEventRow> {
  /// Primary key (UUID v7).
  final String id;

  /// The played track.
  final String trackId;

  /// When playback started.
  final DateTime startedAt;

  /// How much of the track was actually played, in milliseconds.
  final int playedDuration;

  /// Whether the track played to completion.
  final bool completed;
  const PlayEventRow({
    required this.id,
    required this.trackId,
    required this.startedAt,
    required this.playedDuration,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['track_id'] = Variable<String>(trackId);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['played_duration'] = Variable<int>(playedDuration);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  PlayEventTableCompanion toCompanion(bool nullToAbsent) {
    return PlayEventTableCompanion(
      id: Value(id),
      trackId: Value(trackId),
      startedAt: Value(startedAt),
      playedDuration: Value(playedDuration),
      completed: Value(completed),
    );
  }

  factory PlayEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayEventRow(
      id: serializer.fromJson<String>(json['id']),
      trackId: serializer.fromJson<String>(json['trackId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      playedDuration: serializer.fromJson<int>(json['playedDuration']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackId': serializer.toJson<String>(trackId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'playedDuration': serializer.toJson<int>(playedDuration),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  PlayEventRow copyWith({
    String? id,
    String? trackId,
    DateTime? startedAt,
    int? playedDuration,
    bool? completed,
  }) => PlayEventRow(
    id: id ?? this.id,
    trackId: trackId ?? this.trackId,
    startedAt: startedAt ?? this.startedAt,
    playedDuration: playedDuration ?? this.playedDuration,
    completed: completed ?? this.completed,
  );
  PlayEventRow copyWithCompanion(PlayEventTableCompanion data) {
    return PlayEventRow(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      playedDuration: data.playedDuration.present
          ? data.playedDuration.value
          : this.playedDuration,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayEventRow(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('startedAt: $startedAt, ')
          ..write('playedDuration: $playedDuration, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, trackId, startedAt, playedDuration, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayEventRow &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.startedAt == this.startedAt &&
          other.playedDuration == this.playedDuration &&
          other.completed == this.completed);
}

class PlayEventTableCompanion extends UpdateCompanion<PlayEventRow> {
  final Value<String> id;
  final Value<String> trackId;
  final Value<DateTime> startedAt;
  final Value<int> playedDuration;
  final Value<bool> completed;
  final Value<int> rowid;
  const PlayEventTableCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.playedDuration = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayEventTableCompanion.insert({
    required String id,
    required String trackId,
    required DateTime startedAt,
    required int playedDuration,
    required bool completed,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trackId = Value(trackId),
       startedAt = Value(startedAt),
       playedDuration = Value(playedDuration),
       completed = Value(completed);
  static Insertable<PlayEventRow> custom({
    Expression<String>? id,
    Expression<String>? trackId,
    Expression<DateTime>? startedAt,
    Expression<int>? playedDuration,
    Expression<bool>? completed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (startedAt != null) 'started_at': startedAt,
      if (playedDuration != null) 'played_duration': playedDuration,
      if (completed != null) 'completed': completed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayEventTableCompanion copyWith({
    Value<String>? id,
    Value<String>? trackId,
    Value<DateTime>? startedAt,
    Value<int>? playedDuration,
    Value<bool>? completed,
    Value<int>? rowid,
  }) {
    return PlayEventTableCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      startedAt: startedAt ?? this.startedAt,
      playedDuration: playedDuration ?? this.playedDuration,
      completed: completed ?? this.completed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (playedDuration.present) {
      map['played_duration'] = Variable<int>(playedDuration.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayEventTableCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('startedAt: $startedAt, ')
          ..write('playedDuration: $playedDuration, ')
          ..write('completed: $completed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LyricsTableTable extends LyricsTable
    with TableInfo<$LyricsTableTable, LyricsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LyricsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES track_table (id)',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackId,
    content,
    source,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lyrics_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LyricsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {trackId},
  ];
  @override
  LyricsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LyricsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $LyricsTableTable createAlias(String alias) {
    return $LyricsTableTable(attachedDatabase, alias);
  }
}

class LyricsRow extends DataClass implements Insertable<LyricsRow> {
  /// Primary key (UUID v7).
  final String id;

  /// The track this entry belongs to.
  final String trackId;

  /// Raw lyrics text, `null` when [source] is `none`.
  final String? content;

  /// Where [content] came from: `embedded`, `file` or `none`.
  final String source;

  /// When this entry was resolved.
  final DateTime fetchedAt;
  const LyricsRow({
    required this.id,
    required this.trackId,
    this.content,
    required this.source,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['track_id'] = Variable<String>(trackId);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['source'] = Variable<String>(source);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  LyricsTableCompanion toCompanion(bool nullToAbsent) {
    return LyricsTableCompanion(
      id: Value(id),
      trackId: Value(trackId),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      source: Value(source),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory LyricsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LyricsRow(
      id: serializer.fromJson<String>(json['id']),
      trackId: serializer.fromJson<String>(json['trackId']),
      content: serializer.fromJson<String?>(json['content']),
      source: serializer.fromJson<String>(json['source']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackId': serializer.toJson<String>(trackId),
      'content': serializer.toJson<String?>(content),
      'source': serializer.toJson<String>(source),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  LyricsRow copyWith({
    String? id,
    String? trackId,
    Value<String?> content = const Value.absent(),
    String? source,
    DateTime? fetchedAt,
  }) => LyricsRow(
    id: id ?? this.id,
    trackId: trackId ?? this.trackId,
    content: content.present ? content.value : this.content,
    source: source ?? this.source,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  LyricsRow copyWithCompanion(LyricsTableCompanion data) {
    return LyricsRow(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      content: data.content.present ? data.content.value : this.content,
      source: data.source.present ? data.source.value : this.source,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LyricsRow(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('content: $content, ')
          ..write('source: $source, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackId, content, source, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LyricsRow &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.content == this.content &&
          other.source == this.source &&
          other.fetchedAt == this.fetchedAt);
}

class LyricsTableCompanion extends UpdateCompanion<LyricsRow> {
  final Value<String> id;
  final Value<String> trackId;
  final Value<String?> content;
  final Value<String> source;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const LyricsTableCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.content = const Value.absent(),
    this.source = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LyricsTableCompanion.insert({
    required String id,
    required String trackId,
    this.content = const Value.absent(),
    required String source,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trackId = Value(trackId),
       source = Value(source),
       fetchedAt = Value(fetchedAt);
  static Insertable<LyricsRow> custom({
    Expression<String>? id,
    Expression<String>? trackId,
    Expression<String>? content,
    Expression<String>? source,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (content != null) 'content': content,
      if (source != null) 'source': source,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LyricsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? trackId,
    Value<String?>? content,
    Value<String>? source,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return LyricsTableCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      content: content ?? this.content,
      source: source ?? this.source,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LyricsTableCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('content: $content, ')
          ..write('source: $source, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTableTable extends SearchHistoryTable
    with TableInfo<$SearchHistoryTableTable, SearchHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _termMeta = const VerificationMeta('term');
  @override
  late final GeneratedColumn<String> term = GeneratedColumn<String>(
    'term',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchedAtMeta = const VerificationMeta(
    'searchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> searchedAt = GeneratedColumn<DateTime>(
    'searched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, term, searchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SearchHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('term')) {
      context.handle(
        _termMeta,
        term.isAcceptableOrUnknown(data['term']!, _termMeta),
      );
    } else if (isInserting) {
      context.missing(_termMeta);
    }
    if (data.containsKey('searched_at')) {
      context.handle(
        _searchedAtMeta,
        searchedAt.isAcceptableOrUnknown(data['searched_at']!, _searchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_searchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      term: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}term'],
      )!,
      searchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}searched_at'],
      )!,
    );
  }

  @override
  $SearchHistoryTableTable createAlias(String alias) {
    return $SearchHistoryTableTable(attachedDatabase, alias);
  }
}

class SearchHistoryRow extends DataClass
    implements Insertable<SearchHistoryRow> {
  /// Primary key (UUID v7).
  final String id;

  /// The searched term, trimmed.
  final String term;

  /// When this term was last searched.
  final DateTime searchedAt;
  const SearchHistoryRow({
    required this.id,
    required this.term,
    required this.searchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['term'] = Variable<String>(term);
    map['searched_at'] = Variable<DateTime>(searchedAt);
    return map;
  }

  SearchHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryTableCompanion(
      id: Value(id),
      term: Value(term),
      searchedAt: Value(searchedAt),
    );
  }

  factory SearchHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryRow(
      id: serializer.fromJson<String>(json['id']),
      term: serializer.fromJson<String>(json['term']),
      searchedAt: serializer.fromJson<DateTime>(json['searchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'term': serializer.toJson<String>(term),
      'searchedAt': serializer.toJson<DateTime>(searchedAt),
    };
  }

  SearchHistoryRow copyWith({String? id, String? term, DateTime? searchedAt}) =>
      SearchHistoryRow(
        id: id ?? this.id,
        term: term ?? this.term,
        searchedAt: searchedAt ?? this.searchedAt,
      );
  SearchHistoryRow copyWithCompanion(SearchHistoryTableCompanion data) {
    return SearchHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      term: data.term.present ? data.term.value : this.term,
      searchedAt: data.searchedAt.present
          ? data.searchedAt.value
          : this.searchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryRow(')
          ..write('id: $id, ')
          ..write('term: $term, ')
          ..write('searchedAt: $searchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, term, searchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryRow &&
          other.id == this.id &&
          other.term == this.term &&
          other.searchedAt == this.searchedAt);
}

class SearchHistoryTableCompanion extends UpdateCompanion<SearchHistoryRow> {
  final Value<String> id;
  final Value<String> term;
  final Value<DateTime> searchedAt;
  final Value<int> rowid;
  const SearchHistoryTableCompanion({
    this.id = const Value.absent(),
    this.term = const Value.absent(),
    this.searchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SearchHistoryTableCompanion.insert({
    required String id,
    required String term,
    required DateTime searchedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       term = Value(term),
       searchedAt = Value(searchedAt);
  static Insertable<SearchHistoryRow> custom({
    Expression<String>? id,
    Expression<String>? term,
    Expression<DateTime>? searchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (term != null) 'term': term,
      if (searchedAt != null) 'searched_at': searchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SearchHistoryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? term,
    Value<DateTime>? searchedAt,
    Value<int>? rowid,
  }) {
    return SearchHistoryTableCompanion(
      id: id ?? this.id,
      term: term ?? this.term,
      searchedAt: searchedAt ?? this.searchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (term.present) {
      map['term'] = Variable<String>(term.value);
    }
    if (searchedAt.present) {
      map['searched_at'] = Variable<DateTime>(searchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('term: $term, ')
          ..write('searchedAt: $searchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExcludedFolderTableTable extends ExcludedFolderTable
    with TableInfo<$ExcludedFolderTableTable, ExcludedFolderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExcludedFolderTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [path];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'excluded_folder_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExcludedFolderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {path};
  @override
  ExcludedFolderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExcludedFolderRow(
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
    );
  }

  @override
  $ExcludedFolderTableTable createAlias(String alias) {
    return $ExcludedFolderTableTable(attachedDatabase, alias);
  }
}

class ExcludedFolderRow extends DataClass
    implements Insertable<ExcludedFolderRow> {
  /// The excluded folder's absolute path.
  final String path;
  const ExcludedFolderRow({required this.path});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['path'] = Variable<String>(path);
    return map;
  }

  ExcludedFolderTableCompanion toCompanion(bool nullToAbsent) {
    return ExcludedFolderTableCompanion(path: Value(path));
  }

  factory ExcludedFolderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExcludedFolderRow(path: serializer.fromJson<String>(json['path']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'path': serializer.toJson<String>(path)};
  }

  ExcludedFolderRow copyWith({String? path}) =>
      ExcludedFolderRow(path: path ?? this.path);
  ExcludedFolderRow copyWithCompanion(ExcludedFolderTableCompanion data) {
    return ExcludedFolderRow(
      path: data.path.present ? data.path.value : this.path,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExcludedFolderRow(')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => path.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExcludedFolderRow && other.path == this.path);
}

class ExcludedFolderTableCompanion extends UpdateCompanion<ExcludedFolderRow> {
  final Value<String> path;
  final Value<int> rowid;
  const ExcludedFolderTableCompanion({
    this.path = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExcludedFolderTableCompanion.insert({
    required String path,
    this.rowid = const Value.absent(),
  }) : path = Value(path);
  static Insertable<ExcludedFolderRow> custom({
    Expression<String>? path,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (path != null) 'path': path,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExcludedFolderTableCompanion copyWith({
    Value<String>? path,
    Value<int>? rowid,
  }) {
    return ExcludedFolderTableCompanion(
      path: path ?? this.path,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExcludedFolderTableCompanion(')
          ..write('path: $path, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ArtistTableTable artistTable = $ArtistTableTable(this);
  late final $AlbumTableTable albumTable = $AlbumTableTable(this);
  late final $TrackTableTable trackTable = $TrackTableTable(this);
  late final $PlaylistTableTable playlistTable = $PlaylistTableTable(this);
  late final $PlaylistTrackTableTable playlistTrackTable =
      $PlaylistTrackTableTable(this);
  late final $FavoriteTableTable favoriteTable = $FavoriteTableTable(this);
  late final $PlayEventTableTable playEventTable = $PlayEventTableTable(this);
  late final $LyricsTableTable lyricsTable = $LyricsTableTable(this);
  late final $SearchHistoryTableTable searchHistoryTable =
      $SearchHistoryTableTable(this);
  late final $ExcludedFolderTableTable excludedFolderTable =
      $ExcludedFolderTableTable(this);
  late final Index artistSourceId = Index(
    'artist_source_id',
    'CREATE INDEX artist_source_id ON artist_table (source_id)',
  );
  late final Index albumSourceId = Index(
    'album_source_id',
    'CREATE INDEX album_source_id ON album_table (source_id)',
  );
  late final Index trackSourceId = Index(
    'track_source_id',
    'CREATE INDEX track_source_id ON track_table (source_id)',
  );
  late final Index playlistTrackPlaylist = Index(
    'playlist_track_playlist',
    'CREATE INDEX playlist_track_playlist ON playlist_track_table (playlist_id, position)',
  );
  late final Index playlistTrackTrack = Index(
    'playlist_track_track',
    'CREATE INDEX playlist_track_track ON playlist_track_table (track_id)',
  );
  late final Index playEventStartedAt = Index(
    'play_event_started_at',
    'CREATE INDEX play_event_started_at ON play_event_table (started_at)',
  );
  late final ArtistDao artistDao = ArtistDao(this as AppDatabase);
  late final AlbumDao albumDao = AlbumDao(this as AppDatabase);
  late final TrackDao trackDao = TrackDao(this as AppDatabase);
  late final PlaylistDao playlistDao = PlaylistDao(this as AppDatabase);
  late final PlaylistTrackDao playlistTrackDao = PlaylistTrackDao(
    this as AppDatabase,
  );
  late final FavoriteDao favoriteDao = FavoriteDao(this as AppDatabase);
  late final PlayEventDao playEventDao = PlayEventDao(this as AppDatabase);
  late final LyricsDao lyricsDao = LyricsDao(this as AppDatabase);
  late final SearchHistoryDao searchHistoryDao = SearchHistoryDao(
    this as AppDatabase,
  );
  late final ExcludedFolderDao excludedFolderDao = ExcludedFolderDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    artistTable,
    albumTable,
    trackTable,
    playlistTable,
    playlistTrackTable,
    favoriteTable,
    playEventTable,
    lyricsTable,
    searchHistoryTable,
    excludedFolderTable,
    artistSourceId,
    albumSourceId,
    trackSourceId,
    playlistTrackPlaylist,
    playlistTrackTrack,
    playEventStartedAt,
  ];
}

typedef $$ArtistTableTableCreateCompanionBuilder =
    ArtistTableCompanion Function({
      required String id,
      required String sourceId,
      required String name,
      required int albumCount,
      required int trackCount,
      Value<int> rowid,
    });
typedef $$ArtistTableTableUpdateCompanionBuilder =
    ArtistTableCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> name,
      Value<int> albumCount,
      Value<int> trackCount,
      Value<int> rowid,
    });

final class $$ArtistTableTableReferences
    extends BaseReferences<_$AppDatabase, $ArtistTableTable, ArtistRow> {
  $$ArtistTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AlbumTableTable, List<AlbumRow>>
  _albumTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.albumTable,
    aliasName: $_aliasNameGenerator(db.artistTable.id, db.albumTable.artistId),
  );

  $$AlbumTableTableProcessedTableManager get albumTableRefs {
    final manager = $$AlbumTableTableTableManager(
      $_db,
      $_db.albumTable,
    ).filter((f) => f.artistId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_albumTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrackTableTable, List<TrackRow>>
  _trackTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trackTable,
    aliasName: $_aliasNameGenerator(db.artistTable.id, db.trackTable.artistId),
  );

  $$TrackTableTableProcessedTableManager get trackTableRefs {
    final manager = $$TrackTableTableTableManager(
      $_db,
      $_db.trackTable,
    ).filter((f) => f.artistId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ArtistTableTableFilterComposer
    extends Composer<_$AppDatabase, $ArtistTableTable> {
  $$ArtistTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get albumCount => $composableBuilder(
    column: $table.albumCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> albumTableRefs(
    Expression<bool> Function($$AlbumTableTableFilterComposer f) f,
  ) {
    final $$AlbumTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.albumTable,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumTableTableFilterComposer(
            $db: $db,
            $table: $db.albumTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trackTableRefs(
    Expression<bool> Function($$TrackTableTableFilterComposer f) f,
  ) {
    final $$TrackTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableFilterComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtistTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ArtistTableTable> {
  $$ArtistTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get albumCount => $composableBuilder(
    column: $table.albumCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArtistTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArtistTableTable> {
  $$ArtistTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get albumCount => $composableBuilder(
    column: $table.albumCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => column,
  );

  Expression<T> albumTableRefs<T extends Object>(
    Expression<T> Function($$AlbumTableTableAnnotationComposer a) f,
  ) {
    final $$AlbumTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.albumTable,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumTableTableAnnotationComposer(
            $db: $db,
            $table: $db.albumTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trackTableRefs<T extends Object>(
    Expression<T> Function($$TrackTableTableAnnotationComposer a) f,
  ) {
    final $$TrackTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableAnnotationComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtistTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArtistTableTable,
          ArtistRow,
          $$ArtistTableTableFilterComposer,
          $$ArtistTableTableOrderingComposer,
          $$ArtistTableTableAnnotationComposer,
          $$ArtistTableTableCreateCompanionBuilder,
          $$ArtistTableTableUpdateCompanionBuilder,
          (ArtistRow, $$ArtistTableTableReferences),
          ArtistRow,
          PrefetchHooks Function({bool albumTableRefs, bool trackTableRefs})
        > {
  $$ArtistTableTableTableManager(_$AppDatabase db, $ArtistTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtistTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtistTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtistTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> albumCount = const Value.absent(),
                Value<int> trackCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtistTableCompanion(
                id: id,
                sourceId: sourceId,
                name: name,
                albumCount: albumCount,
                trackCount: trackCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String name,
                required int albumCount,
                required int trackCount,
                Value<int> rowid = const Value.absent(),
              }) => ArtistTableCompanion.insert(
                id: id,
                sourceId: sourceId,
                name: name,
                albumCount: albumCount,
                trackCount: trackCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ArtistTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({albumTableRefs = false, trackTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (albumTableRefs) db.albumTable,
                    if (trackTableRefs) db.trackTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (albumTableRefs)
                        await $_getPrefetchedData<
                          ArtistRow,
                          $ArtistTableTable,
                          AlbumRow
                        >(
                          currentTable: table,
                          referencedTable: $$ArtistTableTableReferences
                              ._albumTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ArtistTableTableReferences(
                                db,
                                table,
                                p0,
                              ).albumTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.artistId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (trackTableRefs)
                        await $_getPrefetchedData<
                          ArtistRow,
                          $ArtistTableTable,
                          TrackRow
                        >(
                          currentTable: table,
                          referencedTable: $$ArtistTableTableReferences
                              ._trackTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ArtistTableTableReferences(
                                db,
                                table,
                                p0,
                              ).trackTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.artistId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ArtistTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArtistTableTable,
      ArtistRow,
      $$ArtistTableTableFilterComposer,
      $$ArtistTableTableOrderingComposer,
      $$ArtistTableTableAnnotationComposer,
      $$ArtistTableTableCreateCompanionBuilder,
      $$ArtistTableTableUpdateCompanionBuilder,
      (ArtistRow, $$ArtistTableTableReferences),
      ArtistRow,
      PrefetchHooks Function({bool albumTableRefs, bool trackTableRefs})
    >;
typedef $$AlbumTableTableCreateCompanionBuilder =
    AlbumTableCompanion Function({
      required String id,
      required String sourceId,
      required String title,
      required String artistId,
      Value<int?> year,
      required int trackCount,
      required int totalDuration,
      Value<String?> artworkPath,
      Value<int> rowid,
    });
typedef $$AlbumTableTableUpdateCompanionBuilder =
    AlbumTableCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> title,
      Value<String> artistId,
      Value<int?> year,
      Value<int> trackCount,
      Value<int> totalDuration,
      Value<String?> artworkPath,
      Value<int> rowid,
    });

final class $$AlbumTableTableReferences
    extends BaseReferences<_$AppDatabase, $AlbumTableTable, AlbumRow> {
  $$AlbumTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ArtistTableTable _artistIdTable(_$AppDatabase db) =>
      db.artistTable.createAlias(
        $_aliasNameGenerator(db.albumTable.artistId, db.artistTable.id),
      );

  $$ArtistTableTableProcessedTableManager get artistId {
    final $_column = $_itemColumn<String>('artist_id')!;

    final manager = $$ArtistTableTableTableManager(
      $_db,
      $_db.artistTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_artistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TrackTableTable, List<TrackRow>>
  _trackTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trackTable,
    aliasName: $_aliasNameGenerator(db.albumTable.id, db.trackTable.albumId),
  );

  $$TrackTableTableProcessedTableManager get trackTableRefs {
    final manager = $$TrackTableTableTableManager(
      $_db,
      $_db.trackTable,
    ).filter((f) => f.albumId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AlbumTableTableFilterComposer
    extends Composer<_$AppDatabase, $AlbumTableTable> {
  $$AlbumTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => ColumnFilters(column),
  );

  $$ArtistTableTableFilterComposer get artistId {
    final $$ArtistTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artistTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistTableTableFilterComposer(
            $db: $db,
            $table: $db.artistTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> trackTableRefs(
    Expression<bool> Function($$TrackTableTableFilterComposer f) f,
  ) {
    final $$TrackTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.albumId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableFilterComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlbumTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AlbumTableTable> {
  $$AlbumTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => ColumnOrderings(column),
  );

  $$ArtistTableTableOrderingComposer get artistId {
    final $$ArtistTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artistTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistTableTableOrderingComposer(
            $db: $db,
            $table: $db.artistTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlbumTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlbumTableTable> {
  $$AlbumTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get trackCount => $composableBuilder(
    column: $table.trackCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => column,
  );

  $$ArtistTableTableAnnotationComposer get artistId {
    final $$ArtistTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artistTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistTableTableAnnotationComposer(
            $db: $db,
            $table: $db.artistTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> trackTableRefs<T extends Object>(
    Expression<T> Function($$TrackTableTableAnnotationComposer a) f,
  ) {
    final $$TrackTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.albumId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableAnnotationComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlbumTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlbumTableTable,
          AlbumRow,
          $$AlbumTableTableFilterComposer,
          $$AlbumTableTableOrderingComposer,
          $$AlbumTableTableAnnotationComposer,
          $$AlbumTableTableCreateCompanionBuilder,
          $$AlbumTableTableUpdateCompanionBuilder,
          (AlbumRow, $$AlbumTableTableReferences),
          AlbumRow,
          PrefetchHooks Function({bool artistId, bool trackTableRefs})
        > {
  $$AlbumTableTableTableManager(_$AppDatabase db, $AlbumTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlbumTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlbumTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlbumTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> artistId = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<int> trackCount = const Value.absent(),
                Value<int> totalDuration = const Value.absent(),
                Value<String?> artworkPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlbumTableCompanion(
                id: id,
                sourceId: sourceId,
                title: title,
                artistId: artistId,
                year: year,
                trackCount: trackCount,
                totalDuration: totalDuration,
                artworkPath: artworkPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String title,
                required String artistId,
                Value<int?> year = const Value.absent(),
                required int trackCount,
                required int totalDuration,
                Value<String?> artworkPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlbumTableCompanion.insert(
                id: id,
                sourceId: sourceId,
                title: title,
                artistId: artistId,
                year: year,
                trackCount: trackCount,
                totalDuration: totalDuration,
                artworkPath: artworkPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AlbumTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({artistId = false, trackTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (trackTableRefs) db.trackTable],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (artistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.artistId,
                                referencedTable: $$AlbumTableTableReferences
                                    ._artistIdTable(db),
                                referencedColumn: $$AlbumTableTableReferences
                                    ._artistIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (trackTableRefs)
                    await $_getPrefetchedData<
                      AlbumRow,
                      $AlbumTableTable,
                      TrackRow
                    >(
                      currentTable: table,
                      referencedTable: $$AlbumTableTableReferences
                          ._trackTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AlbumTableTableReferences(
                            db,
                            table,
                            p0,
                          ).trackTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.albumId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AlbumTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlbumTableTable,
      AlbumRow,
      $$AlbumTableTableFilterComposer,
      $$AlbumTableTableOrderingComposer,
      $$AlbumTableTableAnnotationComposer,
      $$AlbumTableTableCreateCompanionBuilder,
      $$AlbumTableTableUpdateCompanionBuilder,
      (AlbumRow, $$AlbumTableTableReferences),
      AlbumRow,
      PrefetchHooks Function({bool artistId, bool trackTableRefs})
    >;
typedef $$TrackTableTableCreateCompanionBuilder =
    TrackTableCompanion Function({
      required String id,
      required String sourceId,
      required String filePath,
      required String title,
      required String artistId,
      required String albumId,
      Value<int?> trackNumber,
      Value<int?> discNumber,
      required int duration,
      Value<int?> year,
      Value<String?> genre,
      Value<int?> bitrate,
      Value<int?> sampleRate,
      required String format,
      required int fileSize,
      required bool hasEmbeddedArtwork,
      Value<bool> isMissing,
      required DateTime dateAdded,
      required DateTime dateModified,
      Value<int> rowid,
    });
typedef $$TrackTableTableUpdateCompanionBuilder =
    TrackTableCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> filePath,
      Value<String> title,
      Value<String> artistId,
      Value<String> albumId,
      Value<int?> trackNumber,
      Value<int?> discNumber,
      Value<int> duration,
      Value<int?> year,
      Value<String?> genre,
      Value<int?> bitrate,
      Value<int?> sampleRate,
      Value<String> format,
      Value<int> fileSize,
      Value<bool> hasEmbeddedArtwork,
      Value<bool> isMissing,
      Value<DateTime> dateAdded,
      Value<DateTime> dateModified,
      Value<int> rowid,
    });

final class $$TrackTableTableReferences
    extends BaseReferences<_$AppDatabase, $TrackTableTable, TrackRow> {
  $$TrackTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ArtistTableTable _artistIdTable(_$AppDatabase db) =>
      db.artistTable.createAlias(
        $_aliasNameGenerator(db.trackTable.artistId, db.artistTable.id),
      );

  $$ArtistTableTableProcessedTableManager get artistId {
    final $_column = $_itemColumn<String>('artist_id')!;

    final manager = $$ArtistTableTableTableManager(
      $_db,
      $_db.artistTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_artistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AlbumTableTable _albumIdTable(_$AppDatabase db) =>
      db.albumTable.createAlias(
        $_aliasNameGenerator(db.trackTable.albumId, db.albumTable.id),
      );

  $$AlbumTableTableProcessedTableManager get albumId {
    final $_column = $_itemColumn<String>('album_id')!;

    final manager = $$AlbumTableTableTableManager(
      $_db,
      $_db.albumTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_albumIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlaylistTrackTableTable, List<PlaylistTrackRow>>
  _playlistTrackTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.playlistTrackTable,
        aliasName: $_aliasNameGenerator(
          db.trackTable.id,
          db.playlistTrackTable.trackId,
        ),
      );

  $$PlaylistTrackTableTableProcessedTableManager get playlistTrackTableRefs {
    final manager = $$PlaylistTrackTableTableTableManager(
      $_db,
      $_db.playlistTrackTable,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _playlistTrackTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FavoriteTableTable, List<FavoriteRow>>
  _favoriteTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.favoriteTable,
    aliasName: $_aliasNameGenerator(db.trackTable.id, db.favoriteTable.trackId),
  );

  $$FavoriteTableTableProcessedTableManager get favoriteTableRefs {
    final manager = $$FavoriteTableTableTableManager(
      $_db,
      $_db.favoriteTable,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_favoriteTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlayEventTableTable, List<PlayEventRow>>
  _playEventTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playEventTable,
    aliasName: $_aliasNameGenerator(
      db.trackTable.id,
      db.playEventTable.trackId,
    ),
  );

  $$PlayEventTableTableProcessedTableManager get playEventTableRefs {
    final manager = $$PlayEventTableTableTableManager(
      $_db,
      $_db.playEventTable,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_playEventTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LyricsTableTable, List<LyricsRow>>
  _lyricsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lyricsTable,
    aliasName: $_aliasNameGenerator(db.trackTable.id, db.lyricsTable.trackId),
  );

  $$LyricsTableTableProcessedTableManager get lyricsTableRefs {
    final manager = $$LyricsTableTableTableManager(
      $_db,
      $_db.lyricsTable,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lyricsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TrackTableTableFilterComposer
    extends Composer<_$AppDatabase, $TrackTableTable> {
  $$TrackTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bitrate => $composableBuilder(
    column: $table.bitrate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasEmbeddedArtwork => $composableBuilder(
    column: $table.hasEmbeddedArtwork,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMissing => $composableBuilder(
    column: $table.isMissing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateModified => $composableBuilder(
    column: $table.dateModified,
    builder: (column) => ColumnFilters(column),
  );

  $$ArtistTableTableFilterComposer get artistId {
    final $$ArtistTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artistTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistTableTableFilterComposer(
            $db: $db,
            $table: $db.artistTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlbumTableTableFilterComposer get albumId {
    final $$AlbumTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.albumId,
      referencedTable: $db.albumTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumTableTableFilterComposer(
            $db: $db,
            $table: $db.albumTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> playlistTrackTableRefs(
    Expression<bool> Function($$PlaylistTrackTableTableFilterComposer f) f,
  ) {
    final $$PlaylistTrackTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistTrackTable,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistTrackTableTableFilterComposer(
            $db: $db,
            $table: $db.playlistTrackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> favoriteTableRefs(
    Expression<bool> Function($$FavoriteTableTableFilterComposer f) f,
  ) {
    final $$FavoriteTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favoriteTable,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoriteTableTableFilterComposer(
            $db: $db,
            $table: $db.favoriteTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playEventTableRefs(
    Expression<bool> Function($$PlayEventTableTableFilterComposer f) f,
  ) {
    final $$PlayEventTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playEventTable,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayEventTableTableFilterComposer(
            $db: $db,
            $table: $db.playEventTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lyricsTableRefs(
    Expression<bool> Function($$LyricsTableTableFilterComposer f) f,
  ) {
    final $$LyricsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lyricsTable,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LyricsTableTableFilterComposer(
            $db: $db,
            $table: $db.lyricsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrackTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackTableTable> {
  $$TrackTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bitrate => $composableBuilder(
    column: $table.bitrate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasEmbeddedArtwork => $composableBuilder(
    column: $table.hasEmbeddedArtwork,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMissing => $composableBuilder(
    column: $table.isMissing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateModified => $composableBuilder(
    column: $table.dateModified,
    builder: (column) => ColumnOrderings(column),
  );

  $$ArtistTableTableOrderingComposer get artistId {
    final $$ArtistTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artistTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistTableTableOrderingComposer(
            $db: $db,
            $table: $db.artistTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlbumTableTableOrderingComposer get albumId {
    final $$AlbumTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.albumId,
      referencedTable: $db.albumTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumTableTableOrderingComposer(
            $db: $db,
            $table: $db.albumTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackTableTable> {
  $$TrackTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<int> get bitrate =>
      $composableBuilder(column: $table.bitrate, builder: (column) => column);

  GeneratedColumn<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<bool> get hasEmbeddedArtwork => $composableBuilder(
    column: $table.hasEmbeddedArtwork,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMissing =>
      $composableBuilder(column: $table.isMissing, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<DateTime> get dateModified => $composableBuilder(
    column: $table.dateModified,
    builder: (column) => column,
  );

  $$ArtistTableTableAnnotationComposer get artistId {
    final $$ArtistTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artistTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistTableTableAnnotationComposer(
            $db: $db,
            $table: $db.artistTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlbumTableTableAnnotationComposer get albumId {
    final $$AlbumTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.albumId,
      referencedTable: $db.albumTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumTableTableAnnotationComposer(
            $db: $db,
            $table: $db.albumTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> playlistTrackTableRefs<T extends Object>(
    Expression<T> Function($$PlaylistTrackTableTableAnnotationComposer a) f,
  ) {
    final $$PlaylistTrackTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.playlistTrackTable,
          getReferencedColumn: (t) => t.trackId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PlaylistTrackTableTableAnnotationComposer(
                $db: $db,
                $table: $db.playlistTrackTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> favoriteTableRefs<T extends Object>(
    Expression<T> Function($$FavoriteTableTableAnnotationComposer a) f,
  ) {
    final $$FavoriteTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favoriteTable,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoriteTableTableAnnotationComposer(
            $db: $db,
            $table: $db.favoriteTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playEventTableRefs<T extends Object>(
    Expression<T> Function($$PlayEventTableTableAnnotationComposer a) f,
  ) {
    final $$PlayEventTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playEventTable,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayEventTableTableAnnotationComposer(
            $db: $db,
            $table: $db.playEventTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lyricsTableRefs<T extends Object>(
    Expression<T> Function($$LyricsTableTableAnnotationComposer a) f,
  ) {
    final $$LyricsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lyricsTable,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LyricsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.lyricsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrackTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackTableTable,
          TrackRow,
          $$TrackTableTableFilterComposer,
          $$TrackTableTableOrderingComposer,
          $$TrackTableTableAnnotationComposer,
          $$TrackTableTableCreateCompanionBuilder,
          $$TrackTableTableUpdateCompanionBuilder,
          (TrackRow, $$TrackTableTableReferences),
          TrackRow,
          PrefetchHooks Function({
            bool artistId,
            bool albumId,
            bool playlistTrackTableRefs,
            bool favoriteTableRefs,
            bool playEventTableRefs,
            bool lyricsTableRefs,
          })
        > {
  $$TrackTableTableTableManager(_$AppDatabase db, $TrackTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> artistId = const Value.absent(),
                Value<String> albumId = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<int?> discNumber = const Value.absent(),
                Value<int> duration = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int?> bitrate = const Value.absent(),
                Value<int?> sampleRate = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<bool> hasEmbeddedArtwork = const Value.absent(),
                Value<bool> isMissing = const Value.absent(),
                Value<DateTime> dateAdded = const Value.absent(),
                Value<DateTime> dateModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackTableCompanion(
                id: id,
                sourceId: sourceId,
                filePath: filePath,
                title: title,
                artistId: artistId,
                albumId: albumId,
                trackNumber: trackNumber,
                discNumber: discNumber,
                duration: duration,
                year: year,
                genre: genre,
                bitrate: bitrate,
                sampleRate: sampleRate,
                format: format,
                fileSize: fileSize,
                hasEmbeddedArtwork: hasEmbeddedArtwork,
                isMissing: isMissing,
                dateAdded: dateAdded,
                dateModified: dateModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String filePath,
                required String title,
                required String artistId,
                required String albumId,
                Value<int?> trackNumber = const Value.absent(),
                Value<int?> discNumber = const Value.absent(),
                required int duration,
                Value<int?> year = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int?> bitrate = const Value.absent(),
                Value<int?> sampleRate = const Value.absent(),
                required String format,
                required int fileSize,
                required bool hasEmbeddedArtwork,
                Value<bool> isMissing = const Value.absent(),
                required DateTime dateAdded,
                required DateTime dateModified,
                Value<int> rowid = const Value.absent(),
              }) => TrackTableCompanion.insert(
                id: id,
                sourceId: sourceId,
                filePath: filePath,
                title: title,
                artistId: artistId,
                albumId: albumId,
                trackNumber: trackNumber,
                discNumber: discNumber,
                duration: duration,
                year: year,
                genre: genre,
                bitrate: bitrate,
                sampleRate: sampleRate,
                format: format,
                fileSize: fileSize,
                hasEmbeddedArtwork: hasEmbeddedArtwork,
                isMissing: isMissing,
                dateAdded: dateAdded,
                dateModified: dateModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                artistId = false,
                albumId = false,
                playlistTrackTableRefs = false,
                favoriteTableRefs = false,
                playEventTableRefs = false,
                lyricsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (playlistTrackTableRefs) db.playlistTrackTable,
                    if (favoriteTableRefs) db.favoriteTable,
                    if (playEventTableRefs) db.playEventTable,
                    if (lyricsTableRefs) db.lyricsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (artistId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.artistId,
                                    referencedTable: $$TrackTableTableReferences
                                        ._artistIdTable(db),
                                    referencedColumn:
                                        $$TrackTableTableReferences
                                            ._artistIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (albumId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.albumId,
                                    referencedTable: $$TrackTableTableReferences
                                        ._albumIdTable(db),
                                    referencedColumn:
                                        $$TrackTableTableReferences
                                            ._albumIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playlistTrackTableRefs)
                        await $_getPrefetchedData<
                          TrackRow,
                          $TrackTableTable,
                          PlaylistTrackRow
                        >(
                          currentTable: table,
                          referencedTable: $$TrackTableTableReferences
                              ._playlistTrackTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrackTableTableReferences(
                                db,
                                table,
                                p0,
                              ).playlistTrackTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trackId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (favoriteTableRefs)
                        await $_getPrefetchedData<
                          TrackRow,
                          $TrackTableTable,
                          FavoriteRow
                        >(
                          currentTable: table,
                          referencedTable: $$TrackTableTableReferences
                              ._favoriteTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrackTableTableReferences(
                                db,
                                table,
                                p0,
                              ).favoriteTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trackId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (playEventTableRefs)
                        await $_getPrefetchedData<
                          TrackRow,
                          $TrackTableTable,
                          PlayEventRow
                        >(
                          currentTable: table,
                          referencedTable: $$TrackTableTableReferences
                              ._playEventTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrackTableTableReferences(
                                db,
                                table,
                                p0,
                              ).playEventTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trackId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lyricsTableRefs)
                        await $_getPrefetchedData<
                          TrackRow,
                          $TrackTableTable,
                          LyricsRow
                        >(
                          currentTable: table,
                          referencedTable: $$TrackTableTableReferences
                              ._lyricsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrackTableTableReferences(
                                db,
                                table,
                                p0,
                              ).lyricsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trackId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TrackTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackTableTable,
      TrackRow,
      $$TrackTableTableFilterComposer,
      $$TrackTableTableOrderingComposer,
      $$TrackTableTableAnnotationComposer,
      $$TrackTableTableCreateCompanionBuilder,
      $$TrackTableTableUpdateCompanionBuilder,
      (TrackRow, $$TrackTableTableReferences),
      TrackRow,
      PrefetchHooks Function({
        bool artistId,
        bool albumId,
        bool playlistTrackTableRefs,
        bool favoriteTableRefs,
        bool playEventTableRefs,
        bool lyricsTableRefs,
      })
    >;
typedef $$PlaylistTableTableCreateCompanionBuilder =
    PlaylistTableCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<bool> isFavorite,
      Value<bool> isFavoritesPlaylist,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PlaylistTableTableUpdateCompanionBuilder =
    PlaylistTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<bool> isFavorite,
      Value<bool> isFavoritesPlaylist,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PlaylistTableTableReferences
    extends BaseReferences<_$AppDatabase, $PlaylistTableTable, PlaylistRow> {
  $$PlaylistTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PlaylistTrackTableTable, List<PlaylistTrackRow>>
  _playlistTrackTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.playlistTrackTable,
        aliasName: $_aliasNameGenerator(
          db.playlistTable.id,
          db.playlistTrackTable.playlistId,
        ),
      );

  $$PlaylistTrackTableTableProcessedTableManager get playlistTrackTableRefs {
    final manager = $$PlaylistTrackTableTableTableManager(
      $_db,
      $_db.playlistTrackTable,
    ).filter((f) => f.playlistId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _playlistTrackTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlaylistTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistTableTable> {
  $$PlaylistTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavoritesPlaylist => $composableBuilder(
    column: $table.isFavoritesPlaylist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playlistTrackTableRefs(
    Expression<bool> Function($$PlaylistTrackTableTableFilterComposer f) f,
  ) {
    final $$PlaylistTrackTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistTrackTable,
      getReferencedColumn: (t) => t.playlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistTrackTableTableFilterComposer(
            $db: $db,
            $table: $db.playlistTrackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistTableTable> {
  $$PlaylistTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavoritesPlaylist => $composableBuilder(
    column: $table.isFavoritesPlaylist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaylistTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistTableTable> {
  $$PlaylistTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavoritesPlaylist => $composableBuilder(
    column: $table.isFavoritesPlaylist,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> playlistTrackTableRefs<T extends Object>(
    Expression<T> Function($$PlaylistTrackTableTableAnnotationComposer a) f,
  ) {
    final $$PlaylistTrackTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.playlistTrackTable,
          getReferencedColumn: (t) => t.playlistId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PlaylistTrackTableTableAnnotationComposer(
                $db: $db,
                $table: $db.playlistTrackTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PlaylistTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistTableTable,
          PlaylistRow,
          $$PlaylistTableTableFilterComposer,
          $$PlaylistTableTableOrderingComposer,
          $$PlaylistTableTableAnnotationComposer,
          $$PlaylistTableTableCreateCompanionBuilder,
          $$PlaylistTableTableUpdateCompanionBuilder,
          (PlaylistRow, $$PlaylistTableTableReferences),
          PlaylistRow,
          PrefetchHooks Function({bool playlistTrackTableRefs})
        > {
  $$PlaylistTableTableTableManager(_$AppDatabase db, $PlaylistTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isFavoritesPlaylist = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistTableCompanion(
                id: id,
                name: name,
                description: description,
                isFavorite: isFavorite,
                isFavoritesPlaylist: isFavoritesPlaylist,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isFavoritesPlaylist = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlaylistTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                isFavorite: isFavorite,
                isFavoritesPlaylist: isFavoritesPlaylist,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaylistTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistTrackTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistTrackTableRefs) db.playlistTrackTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistTrackTableRefs)
                    await $_getPrefetchedData<
                      PlaylistRow,
                      $PlaylistTableTable,
                      PlaylistTrackRow
                    >(
                      currentTable: table,
                      referencedTable: $$PlaylistTableTableReferences
                          ._playlistTrackTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlaylistTableTableReferences(
                            db,
                            table,
                            p0,
                          ).playlistTrackTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playlistId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistTableTable,
      PlaylistRow,
      $$PlaylistTableTableFilterComposer,
      $$PlaylistTableTableOrderingComposer,
      $$PlaylistTableTableAnnotationComposer,
      $$PlaylistTableTableCreateCompanionBuilder,
      $$PlaylistTableTableUpdateCompanionBuilder,
      (PlaylistRow, $$PlaylistTableTableReferences),
      PlaylistRow,
      PrefetchHooks Function({bool playlistTrackTableRefs})
    >;
typedef $$PlaylistTrackTableTableCreateCompanionBuilder =
    PlaylistTrackTableCompanion Function({
      Value<int> id,
      required String playlistId,
      required String trackId,
      required int position,
    });
typedef $$PlaylistTrackTableTableUpdateCompanionBuilder =
    PlaylistTrackTableCompanion Function({
      Value<int> id,
      Value<String> playlistId,
      Value<String> trackId,
      Value<int> position,
    });

final class $$PlaylistTrackTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PlaylistTrackTableTable,
          PlaylistTrackRow
        > {
  $$PlaylistTrackTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlaylistTableTable _playlistIdTable(_$AppDatabase db) =>
      db.playlistTable.createAlias(
        $_aliasNameGenerator(
          db.playlistTrackTable.playlistId,
          db.playlistTable.id,
        ),
      );

  $$PlaylistTableTableProcessedTableManager get playlistId {
    final $_column = $_itemColumn<String>('playlist_id')!;

    final manager = $$PlaylistTableTableTableManager(
      $_db,
      $_db.playlistTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TrackTableTable _trackIdTable(_$AppDatabase db) =>
      db.trackTable.createAlias(
        $_aliasNameGenerator(db.playlistTrackTable.trackId, db.trackTable.id),
      );

  $$TrackTableTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<String>('track_id')!;

    final manager = $$TrackTableTableTableManager(
      $_db,
      $_db.trackTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlaylistTrackTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistTrackTableTable> {
  $$PlaylistTrackTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$PlaylistTableTableFilterComposer get playlistId {
    final $$PlaylistTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlistTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistTableTableFilterComposer(
            $db: $db,
            $table: $db.playlistTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrackTableTableFilterComposer get trackId {
    final $$TrackTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableFilterComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistTrackTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistTrackTableTable> {
  $$PlaylistTrackTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlaylistTableTableOrderingComposer get playlistId {
    final $$PlaylistTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlistTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistTableTableOrderingComposer(
            $db: $db,
            $table: $db.playlistTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrackTableTableOrderingComposer get trackId {
    final $$TrackTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableOrderingComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistTrackTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistTrackTableTable> {
  $$PlaylistTrackTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$PlaylistTableTableAnnotationComposer get playlistId {
    final $$PlaylistTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlistTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistTableTableAnnotationComposer(
            $db: $db,
            $table: $db.playlistTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrackTableTableAnnotationComposer get trackId {
    final $$TrackTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableAnnotationComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistTrackTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistTrackTableTable,
          PlaylistTrackRow,
          $$PlaylistTrackTableTableFilterComposer,
          $$PlaylistTrackTableTableOrderingComposer,
          $$PlaylistTrackTableTableAnnotationComposer,
          $$PlaylistTrackTableTableCreateCompanionBuilder,
          $$PlaylistTrackTableTableUpdateCompanionBuilder,
          (PlaylistTrackRow, $$PlaylistTrackTableTableReferences),
          PlaylistTrackRow,
          PrefetchHooks Function({bool playlistId, bool trackId})
        > {
  $$PlaylistTrackTableTableTableManager(
    _$AppDatabase db,
    $PlaylistTrackTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistTrackTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistTrackTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistTrackTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> playlistId = const Value.absent(),
                Value<String> trackId = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => PlaylistTrackTableCompanion(
                id: id,
                playlistId: playlistId,
                trackId: trackId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String playlistId,
                required String trackId,
                required int position,
              }) => PlaylistTrackTableCompanion.insert(
                id: id,
                playlistId: playlistId,
                trackId: trackId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaylistTrackTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistId = false, trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (playlistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playlistId,
                                referencedTable:
                                    $$PlaylistTrackTableTableReferences
                                        ._playlistIdTable(db),
                                referencedColumn:
                                    $$PlaylistTrackTableTableReferences
                                        ._playlistIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (trackId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trackId,
                                referencedTable:
                                    $$PlaylistTrackTableTableReferences
                                        ._trackIdTable(db),
                                referencedColumn:
                                    $$PlaylistTrackTableTableReferences
                                        ._trackIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistTrackTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistTrackTableTable,
      PlaylistTrackRow,
      $$PlaylistTrackTableTableFilterComposer,
      $$PlaylistTrackTableTableOrderingComposer,
      $$PlaylistTrackTableTableAnnotationComposer,
      $$PlaylistTrackTableTableCreateCompanionBuilder,
      $$PlaylistTrackTableTableUpdateCompanionBuilder,
      (PlaylistTrackRow, $$PlaylistTrackTableTableReferences),
      PlaylistTrackRow,
      PrefetchHooks Function({bool playlistId, bool trackId})
    >;
typedef $$FavoriteTableTableCreateCompanionBuilder =
    FavoriteTableCompanion Function({
      required String id,
      required String trackId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$FavoriteTableTableUpdateCompanionBuilder =
    FavoriteTableCompanion Function({
      Value<String> id,
      Value<String> trackId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$FavoriteTableTableReferences
    extends BaseReferences<_$AppDatabase, $FavoriteTableTable, FavoriteRow> {
  $$FavoriteTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrackTableTable _trackIdTable(_$AppDatabase db) =>
      db.trackTable.createAlias(
        $_aliasNameGenerator(db.favoriteTable.trackId, db.trackTable.id),
      );

  $$TrackTableTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<String>('track_id')!;

    final manager = $$TrackTableTableTableManager(
      $_db,
      $_db.trackTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FavoriteTableTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteTableTable> {
  $$FavoriteTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TrackTableTableFilterComposer get trackId {
    final $$TrackTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableFilterComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoriteTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteTableTable> {
  $$FavoriteTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrackTableTableOrderingComposer get trackId {
    final $$TrackTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableOrderingComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoriteTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteTableTable> {
  $$FavoriteTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TrackTableTableAnnotationComposer get trackId {
    final $$TrackTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableAnnotationComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoriteTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteTableTable,
          FavoriteRow,
          $$FavoriteTableTableFilterComposer,
          $$FavoriteTableTableOrderingComposer,
          $$FavoriteTableTableAnnotationComposer,
          $$FavoriteTableTableCreateCompanionBuilder,
          $$FavoriteTableTableUpdateCompanionBuilder,
          (FavoriteRow, $$FavoriteTableTableReferences),
          FavoriteRow,
          PrefetchHooks Function({bool trackId})
        > {
  $$FavoriteTableTableTableManager(_$AppDatabase db, $FavoriteTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trackId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteTableCompanion(
                id: id,
                trackId: trackId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trackId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => FavoriteTableCompanion.insert(
                id: id,
                trackId: trackId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FavoriteTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (trackId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trackId,
                                referencedTable: $$FavoriteTableTableReferences
                                    ._trackIdTable(db),
                                referencedColumn: $$FavoriteTableTableReferences
                                    ._trackIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FavoriteTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteTableTable,
      FavoriteRow,
      $$FavoriteTableTableFilterComposer,
      $$FavoriteTableTableOrderingComposer,
      $$FavoriteTableTableAnnotationComposer,
      $$FavoriteTableTableCreateCompanionBuilder,
      $$FavoriteTableTableUpdateCompanionBuilder,
      (FavoriteRow, $$FavoriteTableTableReferences),
      FavoriteRow,
      PrefetchHooks Function({bool trackId})
    >;
typedef $$PlayEventTableTableCreateCompanionBuilder =
    PlayEventTableCompanion Function({
      required String id,
      required String trackId,
      required DateTime startedAt,
      required int playedDuration,
      required bool completed,
      Value<int> rowid,
    });
typedef $$PlayEventTableTableUpdateCompanionBuilder =
    PlayEventTableCompanion Function({
      Value<String> id,
      Value<String> trackId,
      Value<DateTime> startedAt,
      Value<int> playedDuration,
      Value<bool> completed,
      Value<int> rowid,
    });

final class $$PlayEventTableTableReferences
    extends BaseReferences<_$AppDatabase, $PlayEventTableTable, PlayEventRow> {
  $$PlayEventTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrackTableTable _trackIdTable(_$AppDatabase db) =>
      db.trackTable.createAlias(
        $_aliasNameGenerator(db.playEventTable.trackId, db.trackTable.id),
      );

  $$TrackTableTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<String>('track_id')!;

    final manager = $$TrackTableTableTableManager(
      $_db,
      $_db.trackTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlayEventTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlayEventTableTable> {
  $$PlayEventTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playedDuration => $composableBuilder(
    column: $table.playedDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  $$TrackTableTableFilterComposer get trackId {
    final $$TrackTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableFilterComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayEventTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayEventTableTable> {
  $$PlayEventTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playedDuration => $composableBuilder(
    column: $table.playedDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrackTableTableOrderingComposer get trackId {
    final $$TrackTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableOrderingComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayEventTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayEventTableTable> {
  $$PlayEventTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get playedDuration => $composableBuilder(
    column: $table.playedDuration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  $$TrackTableTableAnnotationComposer get trackId {
    final $$TrackTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableAnnotationComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayEventTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayEventTableTable,
          PlayEventRow,
          $$PlayEventTableTableFilterComposer,
          $$PlayEventTableTableOrderingComposer,
          $$PlayEventTableTableAnnotationComposer,
          $$PlayEventTableTableCreateCompanionBuilder,
          $$PlayEventTableTableUpdateCompanionBuilder,
          (PlayEventRow, $$PlayEventTableTableReferences),
          PlayEventRow,
          PrefetchHooks Function({bool trackId})
        > {
  $$PlayEventTableTableTableManager(
    _$AppDatabase db,
    $PlayEventTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayEventTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayEventTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayEventTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trackId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> playedDuration = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayEventTableCompanion(
                id: id,
                trackId: trackId,
                startedAt: startedAt,
                playedDuration: playedDuration,
                completed: completed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trackId,
                required DateTime startedAt,
                required int playedDuration,
                required bool completed,
                Value<int> rowid = const Value.absent(),
              }) => PlayEventTableCompanion.insert(
                id: id,
                trackId: trackId,
                startedAt: startedAt,
                playedDuration: playedDuration,
                completed: completed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayEventTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (trackId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trackId,
                                referencedTable: $$PlayEventTableTableReferences
                                    ._trackIdTable(db),
                                referencedColumn:
                                    $$PlayEventTableTableReferences
                                        ._trackIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlayEventTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayEventTableTable,
      PlayEventRow,
      $$PlayEventTableTableFilterComposer,
      $$PlayEventTableTableOrderingComposer,
      $$PlayEventTableTableAnnotationComposer,
      $$PlayEventTableTableCreateCompanionBuilder,
      $$PlayEventTableTableUpdateCompanionBuilder,
      (PlayEventRow, $$PlayEventTableTableReferences),
      PlayEventRow,
      PrefetchHooks Function({bool trackId})
    >;
typedef $$LyricsTableTableCreateCompanionBuilder =
    LyricsTableCompanion Function({
      required String id,
      required String trackId,
      Value<String?> content,
      required String source,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$LyricsTableTableUpdateCompanionBuilder =
    LyricsTableCompanion Function({
      Value<String> id,
      Value<String> trackId,
      Value<String?> content,
      Value<String> source,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

final class $$LyricsTableTableReferences
    extends BaseReferences<_$AppDatabase, $LyricsTableTable, LyricsRow> {
  $$LyricsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TrackTableTable _trackIdTable(_$AppDatabase db) =>
      db.trackTable.createAlias(
        $_aliasNameGenerator(db.lyricsTable.trackId, db.trackTable.id),
      );

  $$TrackTableTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<String>('track_id')!;

    final manager = $$TrackTableTableTableManager(
      $_db,
      $_db.trackTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LyricsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TrackTableTableFilterComposer get trackId {
    final $$TrackTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableFilterComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LyricsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrackTableTableOrderingComposer get trackId {
    final $$TrackTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableOrderingComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LyricsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  $$TrackTableTableAnnotationComposer get trackId {
    final $$TrackTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.trackTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackTableTableAnnotationComposer(
            $db: $db,
            $table: $db.trackTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LyricsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LyricsTableTable,
          LyricsRow,
          $$LyricsTableTableFilterComposer,
          $$LyricsTableTableOrderingComposer,
          $$LyricsTableTableAnnotationComposer,
          $$LyricsTableTableCreateCompanionBuilder,
          $$LyricsTableTableUpdateCompanionBuilder,
          (LyricsRow, $$LyricsTableTableReferences),
          LyricsRow,
          PrefetchHooks Function({bool trackId})
        > {
  $$LyricsTableTableTableManager(_$AppDatabase db, $LyricsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LyricsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LyricsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LyricsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trackId = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LyricsTableCompanion(
                id: id,
                trackId: trackId,
                content: content,
                source: source,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trackId,
                Value<String?> content = const Value.absent(),
                required String source,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => LyricsTableCompanion.insert(
                id: id,
                trackId: trackId,
                content: content,
                source: source,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LyricsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (trackId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trackId,
                                referencedTable: $$LyricsTableTableReferences
                                    ._trackIdTable(db),
                                referencedColumn: $$LyricsTableTableReferences
                                    ._trackIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LyricsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LyricsTableTable,
      LyricsRow,
      $$LyricsTableTableFilterComposer,
      $$LyricsTableTableOrderingComposer,
      $$LyricsTableTableAnnotationComposer,
      $$LyricsTableTableCreateCompanionBuilder,
      $$LyricsTableTableUpdateCompanionBuilder,
      (LyricsRow, $$LyricsTableTableReferences),
      LyricsRow,
      PrefetchHooks Function({bool trackId})
    >;
typedef $$SearchHistoryTableTableCreateCompanionBuilder =
    SearchHistoryTableCompanion Function({
      required String id,
      required String term,
      required DateTime searchedAt,
      Value<int> rowid,
    });
typedef $$SearchHistoryTableTableUpdateCompanionBuilder =
    SearchHistoryTableCompanion Function({
      Value<String> id,
      Value<String> term,
      Value<DateTime> searchedAt,
      Value<int> rowid,
    });

class $$SearchHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get term => $composableBuilder(
    column: $table.term,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get searchedAt => $composableBuilder(
    column: $table.searchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SearchHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get term => $composableBuilder(
    column: $table.term,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get searchedAt => $composableBuilder(
    column: $table.searchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SearchHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get term =>
      $composableBuilder(column: $table.term, builder: (column) => column);

  GeneratedColumn<DateTime> get searchedAt => $composableBuilder(
    column: $table.searchedAt,
    builder: (column) => column,
  );
}

class $$SearchHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SearchHistoryTableTable,
          SearchHistoryRow,
          $$SearchHistoryTableTableFilterComposer,
          $$SearchHistoryTableTableOrderingComposer,
          $$SearchHistoryTableTableAnnotationComposer,
          $$SearchHistoryTableTableCreateCompanionBuilder,
          $$SearchHistoryTableTableUpdateCompanionBuilder,
          (
            SearchHistoryRow,
            BaseReferences<
              _$AppDatabase,
              $SearchHistoryTableTable,
              SearchHistoryRow
            >,
          ),
          SearchHistoryRow,
          PrefetchHooks Function()
        > {
  $$SearchHistoryTableTableTableManager(
    _$AppDatabase db,
    $SearchHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchHistoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> term = const Value.absent(),
                Value<DateTime> searchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SearchHistoryTableCompanion(
                id: id,
                term: term,
                searchedAt: searchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String term,
                required DateTime searchedAt,
                Value<int> rowid = const Value.absent(),
              }) => SearchHistoryTableCompanion.insert(
                id: id,
                term: term,
                searchedAt: searchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SearchHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SearchHistoryTableTable,
      SearchHistoryRow,
      $$SearchHistoryTableTableFilterComposer,
      $$SearchHistoryTableTableOrderingComposer,
      $$SearchHistoryTableTableAnnotationComposer,
      $$SearchHistoryTableTableCreateCompanionBuilder,
      $$SearchHistoryTableTableUpdateCompanionBuilder,
      (
        SearchHistoryRow,
        BaseReferences<
          _$AppDatabase,
          $SearchHistoryTableTable,
          SearchHistoryRow
        >,
      ),
      SearchHistoryRow,
      PrefetchHooks Function()
    >;
typedef $$ExcludedFolderTableTableCreateCompanionBuilder =
    ExcludedFolderTableCompanion Function({
      required String path,
      Value<int> rowid,
    });
typedef $$ExcludedFolderTableTableUpdateCompanionBuilder =
    ExcludedFolderTableCompanion Function({
      Value<String> path,
      Value<int> rowid,
    });

class $$ExcludedFolderTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExcludedFolderTableTable> {
  $$ExcludedFolderTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExcludedFolderTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExcludedFolderTableTable> {
  $$ExcludedFolderTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExcludedFolderTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExcludedFolderTableTable> {
  $$ExcludedFolderTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);
}

class $$ExcludedFolderTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExcludedFolderTableTable,
          ExcludedFolderRow,
          $$ExcludedFolderTableTableFilterComposer,
          $$ExcludedFolderTableTableOrderingComposer,
          $$ExcludedFolderTableTableAnnotationComposer,
          $$ExcludedFolderTableTableCreateCompanionBuilder,
          $$ExcludedFolderTableTableUpdateCompanionBuilder,
          (
            ExcludedFolderRow,
            BaseReferences<
              _$AppDatabase,
              $ExcludedFolderTableTable,
              ExcludedFolderRow
            >,
          ),
          ExcludedFolderRow,
          PrefetchHooks Function()
        > {
  $$ExcludedFolderTableTableTableManager(
    _$AppDatabase db,
    $ExcludedFolderTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExcludedFolderTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExcludedFolderTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExcludedFolderTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> path = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExcludedFolderTableCompanion(path: path, rowid: rowid),
          createCompanionCallback:
              ({
                required String path,
                Value<int> rowid = const Value.absent(),
              }) =>
                  ExcludedFolderTableCompanion.insert(path: path, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExcludedFolderTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExcludedFolderTableTable,
      ExcludedFolderRow,
      $$ExcludedFolderTableTableFilterComposer,
      $$ExcludedFolderTableTableOrderingComposer,
      $$ExcludedFolderTableTableAnnotationComposer,
      $$ExcludedFolderTableTableCreateCompanionBuilder,
      $$ExcludedFolderTableTableUpdateCompanionBuilder,
      (
        ExcludedFolderRow,
        BaseReferences<
          _$AppDatabase,
          $ExcludedFolderTableTable,
          ExcludedFolderRow
        >,
      ),
      ExcludedFolderRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ArtistTableTableTableManager get artistTable =>
      $$ArtistTableTableTableManager(_db, _db.artistTable);
  $$AlbumTableTableTableManager get albumTable =>
      $$AlbumTableTableTableManager(_db, _db.albumTable);
  $$TrackTableTableTableManager get trackTable =>
      $$TrackTableTableTableManager(_db, _db.trackTable);
  $$PlaylistTableTableTableManager get playlistTable =>
      $$PlaylistTableTableTableManager(_db, _db.playlistTable);
  $$PlaylistTrackTableTableTableManager get playlistTrackTable =>
      $$PlaylistTrackTableTableTableManager(_db, _db.playlistTrackTable);
  $$FavoriteTableTableTableManager get favoriteTable =>
      $$FavoriteTableTableTableManager(_db, _db.favoriteTable);
  $$PlayEventTableTableTableManager get playEventTable =>
      $$PlayEventTableTableTableManager(_db, _db.playEventTable);
  $$LyricsTableTableTableManager get lyricsTable =>
      $$LyricsTableTableTableManager(_db, _db.lyricsTable);
  $$SearchHistoryTableTableTableManager get searchHistoryTable =>
      $$SearchHistoryTableTableTableManager(_db, _db.searchHistoryTable);
  $$ExcludedFolderTableTableTableManager get excludedFolderTable =>
      $$ExcludedFolderTableTableTableManager(_db, _db.excludedFolderTable);
}
