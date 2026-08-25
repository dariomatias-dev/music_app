// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupSnapshot {

 int get formatVersion; DateTime get createdAt; List<BackupPlaylist> get playlists; List<String> get favoriteTrackSourceIds; List<BackupPlayEvent> get playHistory; List<String> get excludedFolders; List<String> get searchHistoryTerms; BackupSettings get settings;
/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupSnapshotCopyWith<BackupSnapshot> get copyWith => _$BackupSnapshotCopyWithImpl<BackupSnapshot>(this as BackupSnapshot, _$identity);

  /// Serializes this BackupSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupSnapshot&&(identical(other.formatVersion, formatVersion) || other.formatVersion == formatVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.playlists, playlists)&&const DeepCollectionEquality().equals(other.favoriteTrackSourceIds, favoriteTrackSourceIds)&&const DeepCollectionEquality().equals(other.playHistory, playHistory)&&const DeepCollectionEquality().equals(other.excludedFolders, excludedFolders)&&const DeepCollectionEquality().equals(other.searchHistoryTerms, searchHistoryTerms)&&(identical(other.settings, settings) || other.settings == settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formatVersion,createdAt,const DeepCollectionEquality().hash(playlists),const DeepCollectionEquality().hash(favoriteTrackSourceIds),const DeepCollectionEquality().hash(playHistory),const DeepCollectionEquality().hash(excludedFolders),const DeepCollectionEquality().hash(searchHistoryTerms),settings);

@override
String toString() {
  return 'BackupSnapshot(formatVersion: $formatVersion, createdAt: $createdAt, playlists: $playlists, favoriteTrackSourceIds: $favoriteTrackSourceIds, playHistory: $playHistory, excludedFolders: $excludedFolders, searchHistoryTerms: $searchHistoryTerms, settings: $settings)';
}


}

/// @nodoc
abstract mixin class $BackupSnapshotCopyWith<$Res>  {
  factory $BackupSnapshotCopyWith(BackupSnapshot value, $Res Function(BackupSnapshot) _then) = _$BackupSnapshotCopyWithImpl;
@useResult
$Res call({
 int formatVersion, DateTime createdAt, List<BackupPlaylist> playlists, List<String> favoriteTrackSourceIds, List<BackupPlayEvent> playHistory, List<String> excludedFolders, List<String> searchHistoryTerms, BackupSettings settings
});


$BackupSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$BackupSnapshotCopyWithImpl<$Res>
    implements $BackupSnapshotCopyWith<$Res> {
  _$BackupSnapshotCopyWithImpl(this._self, this._then);

  final BackupSnapshot _self;
  final $Res Function(BackupSnapshot) _then;

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formatVersion = null,Object? createdAt = null,Object? playlists = null,Object? favoriteTrackSourceIds = null,Object? playHistory = null,Object? excludedFolders = null,Object? searchHistoryTerms = null,Object? settings = null,}) {
  return _then(_self.copyWith(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,playlists: null == playlists ? _self.playlists : playlists // ignore: cast_nullable_to_non_nullable
as List<BackupPlaylist>,favoriteTrackSourceIds: null == favoriteTrackSourceIds ? _self.favoriteTrackSourceIds : favoriteTrackSourceIds // ignore: cast_nullable_to_non_nullable
as List<String>,playHistory: null == playHistory ? _self.playHistory : playHistory // ignore: cast_nullable_to_non_nullable
as List<BackupPlayEvent>,excludedFolders: null == excludedFolders ? _self.excludedFolders : excludedFolders // ignore: cast_nullable_to_non_nullable
as List<String>,searchHistoryTerms: null == searchHistoryTerms ? _self.searchHistoryTerms : searchHistoryTerms // ignore: cast_nullable_to_non_nullable
as List<String>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as BackupSettings,
  ));
}
/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupSettingsCopyWith<$Res> get settings {
  
  return $BackupSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [BackupSnapshot].
extension BackupSnapshotPatterns on BackupSnapshot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _BackupSnapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int formatVersion,  DateTime createdAt,  List<BackupPlaylist> playlists,  List<String> favoriteTrackSourceIds,  List<BackupPlayEvent> playHistory,  List<String> excludedFolders,  List<String> searchHistoryTerms,  BackupSettings settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
return $default(_that.formatVersion,_that.createdAt,_that.playlists,_that.favoriteTrackSourceIds,_that.playHistory,_that.excludedFolders,_that.searchHistoryTerms,_that.settings);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int formatVersion,  DateTime createdAt,  List<BackupPlaylist> playlists,  List<String> favoriteTrackSourceIds,  List<BackupPlayEvent> playHistory,  List<String> excludedFolders,  List<String> searchHistoryTerms,  BackupSettings settings)  $default,) {final _that = this;
switch (_that) {
case _BackupSnapshot():
return $default(_that.formatVersion,_that.createdAt,_that.playlists,_that.favoriteTrackSourceIds,_that.playHistory,_that.excludedFolders,_that.searchHistoryTerms,_that.settings);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int formatVersion,  DateTime createdAt,  List<BackupPlaylist> playlists,  List<String> favoriteTrackSourceIds,  List<BackupPlayEvent> playHistory,  List<String> excludedFolders,  List<String> searchHistoryTerms,  BackupSettings settings)?  $default,) {final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
return $default(_that.formatVersion,_that.createdAt,_that.playlists,_that.favoriteTrackSourceIds,_that.playHistory,_that.excludedFolders,_that.searchHistoryTerms,_that.settings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupSnapshot implements BackupSnapshot {
  const _BackupSnapshot({required this.formatVersion, required this.createdAt, required final  List<BackupPlaylist> playlists, required final  List<String> favoriteTrackSourceIds, required final  List<BackupPlayEvent> playHistory, required final  List<String> excludedFolders, required final  List<String> searchHistoryTerms, required this.settings}): _playlists = playlists,_favoriteTrackSourceIds = favoriteTrackSourceIds,_playHistory = playHistory,_excludedFolders = excludedFolders,_searchHistoryTerms = searchHistoryTerms;
  factory _BackupSnapshot.fromJson(Map<String, dynamic> json) => _$BackupSnapshotFromJson(json);

@override final  int formatVersion;
@override final  DateTime createdAt;
 final  List<BackupPlaylist> _playlists;
@override List<BackupPlaylist> get playlists {
  if (_playlists is EqualUnmodifiableListView) return _playlists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playlists);
}

 final  List<String> _favoriteTrackSourceIds;
@override List<String> get favoriteTrackSourceIds {
  if (_favoriteTrackSourceIds is EqualUnmodifiableListView) return _favoriteTrackSourceIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteTrackSourceIds);
}

 final  List<BackupPlayEvent> _playHistory;
@override List<BackupPlayEvent> get playHistory {
  if (_playHistory is EqualUnmodifiableListView) return _playHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playHistory);
}

 final  List<String> _excludedFolders;
@override List<String> get excludedFolders {
  if (_excludedFolders is EqualUnmodifiableListView) return _excludedFolders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_excludedFolders);
}

 final  List<String> _searchHistoryTerms;
@override List<String> get searchHistoryTerms {
  if (_searchHistoryTerms is EqualUnmodifiableListView) return _searchHistoryTerms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchHistoryTerms);
}

@override final  BackupSettings settings;

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupSnapshotCopyWith<_BackupSnapshot> get copyWith => __$BackupSnapshotCopyWithImpl<_BackupSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupSnapshot&&(identical(other.formatVersion, formatVersion) || other.formatVersion == formatVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._playlists, _playlists)&&const DeepCollectionEquality().equals(other._favoriteTrackSourceIds, _favoriteTrackSourceIds)&&const DeepCollectionEquality().equals(other._playHistory, _playHistory)&&const DeepCollectionEquality().equals(other._excludedFolders, _excludedFolders)&&const DeepCollectionEquality().equals(other._searchHistoryTerms, _searchHistoryTerms)&&(identical(other.settings, settings) || other.settings == settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formatVersion,createdAt,const DeepCollectionEquality().hash(_playlists),const DeepCollectionEquality().hash(_favoriteTrackSourceIds),const DeepCollectionEquality().hash(_playHistory),const DeepCollectionEquality().hash(_excludedFolders),const DeepCollectionEquality().hash(_searchHistoryTerms),settings);

@override
String toString() {
  return 'BackupSnapshot(formatVersion: $formatVersion, createdAt: $createdAt, playlists: $playlists, favoriteTrackSourceIds: $favoriteTrackSourceIds, playHistory: $playHistory, excludedFolders: $excludedFolders, searchHistoryTerms: $searchHistoryTerms, settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$BackupSnapshotCopyWith<$Res> implements $BackupSnapshotCopyWith<$Res> {
  factory _$BackupSnapshotCopyWith(_BackupSnapshot value, $Res Function(_BackupSnapshot) _then) = __$BackupSnapshotCopyWithImpl;
@override @useResult
$Res call({
 int formatVersion, DateTime createdAt, List<BackupPlaylist> playlists, List<String> favoriteTrackSourceIds, List<BackupPlayEvent> playHistory, List<String> excludedFolders, List<String> searchHistoryTerms, BackupSettings settings
});


@override $BackupSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$BackupSnapshotCopyWithImpl<$Res>
    implements _$BackupSnapshotCopyWith<$Res> {
  __$BackupSnapshotCopyWithImpl(this._self, this._then);

  final _BackupSnapshot _self;
  final $Res Function(_BackupSnapshot) _then;

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formatVersion = null,Object? createdAt = null,Object? playlists = null,Object? favoriteTrackSourceIds = null,Object? playHistory = null,Object? excludedFolders = null,Object? searchHistoryTerms = null,Object? settings = null,}) {
  return _then(_BackupSnapshot(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,playlists: null == playlists ? _self._playlists : playlists // ignore: cast_nullable_to_non_nullable
as List<BackupPlaylist>,favoriteTrackSourceIds: null == favoriteTrackSourceIds ? _self._favoriteTrackSourceIds : favoriteTrackSourceIds // ignore: cast_nullable_to_non_nullable
as List<String>,playHistory: null == playHistory ? _self._playHistory : playHistory // ignore: cast_nullable_to_non_nullable
as List<BackupPlayEvent>,excludedFolders: null == excludedFolders ? _self._excludedFolders : excludedFolders // ignore: cast_nullable_to_non_nullable
as List<String>,searchHistoryTerms: null == searchHistoryTerms ? _self._searchHistoryTerms : searchHistoryTerms // ignore: cast_nullable_to_non_nullable
as List<String>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as BackupSettings,
  ));
}

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupSettingsCopyWith<$Res> get settings {
  
  return $BackupSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
