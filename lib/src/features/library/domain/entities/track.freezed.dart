// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Track {

 String get id; String get sourceId; String get filePath; String get title; String get artistId; String get albumId; Duration get duration; String get format; int get fileSize; bool get hasEmbeddedArtwork; DateTime get dateAdded; DateTime get dateModified; bool get isMissing; int? get trackNumber; int? get discNumber; int? get year; String? get genre; int? get bitrate; int? get sampleRate;
/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackCopyWith<Track> get copyWith => _$TrackCopyWithImpl<Track>(this as Track, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Track&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.title, title) || other.title == title)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.albumId, albumId) || other.albumId == albumId)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.format, format) || other.format == format)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.hasEmbeddedArtwork, hasEmbeddedArtwork) || other.hasEmbeddedArtwork == hasEmbeddedArtwork)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.dateModified, dateModified) || other.dateModified == dateModified)&&(identical(other.isMissing, isMissing) || other.isMissing == isMissing)&&(identical(other.trackNumber, trackNumber) || other.trackNumber == trackNumber)&&(identical(other.discNumber, discNumber) || other.discNumber == discNumber)&&(identical(other.year, year) || other.year == year)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,sourceId,filePath,title,artistId,albumId,duration,format,fileSize,hasEmbeddedArtwork,dateAdded,dateModified,isMissing,trackNumber,discNumber,year,genre,bitrate,sampleRate]);

@override
String toString() {
  return 'Track(id: $id, sourceId: $sourceId, filePath: $filePath, title: $title, artistId: $artistId, albumId: $albumId, duration: $duration, format: $format, fileSize: $fileSize, hasEmbeddedArtwork: $hasEmbeddedArtwork, dateAdded: $dateAdded, dateModified: $dateModified, isMissing: $isMissing, trackNumber: $trackNumber, discNumber: $discNumber, year: $year, genre: $genre, bitrate: $bitrate, sampleRate: $sampleRate)';
}


}

/// @nodoc
abstract mixin class $TrackCopyWith<$Res>  {
  factory $TrackCopyWith(Track value, $Res Function(Track) _then) = _$TrackCopyWithImpl;
@useResult
$Res call({
 String id, String sourceId, String filePath, String title, String artistId, String albumId, Duration duration, String format, int fileSize, bool hasEmbeddedArtwork, DateTime dateAdded, DateTime dateModified, bool isMissing, int? trackNumber, int? discNumber, int? year, String? genre, int? bitrate, int? sampleRate
});




}
/// @nodoc
class _$TrackCopyWithImpl<$Res>
    implements $TrackCopyWith<$Res> {
  _$TrackCopyWithImpl(this._self, this._then);

  final Track _self;
  final $Res Function(Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceId = null,Object? filePath = null,Object? title = null,Object? artistId = null,Object? albumId = null,Object? duration = null,Object? format = null,Object? fileSize = null,Object? hasEmbeddedArtwork = null,Object? dateAdded = null,Object? dateModified = null,Object? isMissing = null,Object? trackNumber = freezed,Object? discNumber = freezed,Object? year = freezed,Object? genre = freezed,Object? bitrate = freezed,Object? sampleRate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,albumId: null == albumId ? _self.albumId : albumId // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,hasEmbeddedArtwork: null == hasEmbeddedArtwork ? _self.hasEmbeddedArtwork : hasEmbeddedArtwork // ignore: cast_nullable_to_non_nullable
as bool,dateAdded: null == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as DateTime,dateModified: null == dateModified ? _self.dateModified : dateModified // ignore: cast_nullable_to_non_nullable
as DateTime,isMissing: null == isMissing ? _self.isMissing : isMissing // ignore: cast_nullable_to_non_nullable
as bool,trackNumber: freezed == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int?,discNumber: freezed == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,bitrate: freezed == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int?,sampleRate: freezed == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Track].
extension TrackPatterns on Track {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Track value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Track() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Track value)  $default,){
final _that = this;
switch (_that) {
case _Track():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Track value)?  $default,){
final _that = this;
switch (_that) {
case _Track() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceId,  String filePath,  String title,  String artistId,  String albumId,  Duration duration,  String format,  int fileSize,  bool hasEmbeddedArtwork,  DateTime dateAdded,  DateTime dateModified,  bool isMissing,  int? trackNumber,  int? discNumber,  int? year,  String? genre,  int? bitrate,  int? sampleRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.id,_that.sourceId,_that.filePath,_that.title,_that.artistId,_that.albumId,_that.duration,_that.format,_that.fileSize,_that.hasEmbeddedArtwork,_that.dateAdded,_that.dateModified,_that.isMissing,_that.trackNumber,_that.discNumber,_that.year,_that.genre,_that.bitrate,_that.sampleRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceId,  String filePath,  String title,  String artistId,  String albumId,  Duration duration,  String format,  int fileSize,  bool hasEmbeddedArtwork,  DateTime dateAdded,  DateTime dateModified,  bool isMissing,  int? trackNumber,  int? discNumber,  int? year,  String? genre,  int? bitrate,  int? sampleRate)  $default,) {final _that = this;
switch (_that) {
case _Track():
return $default(_that.id,_that.sourceId,_that.filePath,_that.title,_that.artistId,_that.albumId,_that.duration,_that.format,_that.fileSize,_that.hasEmbeddedArtwork,_that.dateAdded,_that.dateModified,_that.isMissing,_that.trackNumber,_that.discNumber,_that.year,_that.genre,_that.bitrate,_that.sampleRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceId,  String filePath,  String title,  String artistId,  String albumId,  Duration duration,  String format,  int fileSize,  bool hasEmbeddedArtwork,  DateTime dateAdded,  DateTime dateModified,  bool isMissing,  int? trackNumber,  int? discNumber,  int? year,  String? genre,  int? bitrate,  int? sampleRate)?  $default,) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.id,_that.sourceId,_that.filePath,_that.title,_that.artistId,_that.albumId,_that.duration,_that.format,_that.fileSize,_that.hasEmbeddedArtwork,_that.dateAdded,_that.dateModified,_that.isMissing,_that.trackNumber,_that.discNumber,_that.year,_that.genre,_that.bitrate,_that.sampleRate);case _:
  return null;

}
}

}

/// @nodoc


class _Track implements Track {
  const _Track({required this.id, required this.sourceId, required this.filePath, required this.title, required this.artistId, required this.albumId, required this.duration, required this.format, required this.fileSize, required this.hasEmbeddedArtwork, required this.dateAdded, required this.dateModified, this.isMissing = false, this.trackNumber, this.discNumber, this.year, this.genre, this.bitrate, this.sampleRate});
  

@override final  String id;
@override final  String sourceId;
@override final  String filePath;
@override final  String title;
@override final  String artistId;
@override final  String albumId;
@override final  Duration duration;
@override final  String format;
@override final  int fileSize;
@override final  bool hasEmbeddedArtwork;
@override final  DateTime dateAdded;
@override final  DateTime dateModified;
@override@JsonKey() final  bool isMissing;
@override final  int? trackNumber;
@override final  int? discNumber;
@override final  int? year;
@override final  String? genre;
@override final  int? bitrate;
@override final  int? sampleRate;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackCopyWith<_Track> get copyWith => __$TrackCopyWithImpl<_Track>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Track&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.title, title) || other.title == title)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.albumId, albumId) || other.albumId == albumId)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.format, format) || other.format == format)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.hasEmbeddedArtwork, hasEmbeddedArtwork) || other.hasEmbeddedArtwork == hasEmbeddedArtwork)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.dateModified, dateModified) || other.dateModified == dateModified)&&(identical(other.isMissing, isMissing) || other.isMissing == isMissing)&&(identical(other.trackNumber, trackNumber) || other.trackNumber == trackNumber)&&(identical(other.discNumber, discNumber) || other.discNumber == discNumber)&&(identical(other.year, year) || other.year == year)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,sourceId,filePath,title,artistId,albumId,duration,format,fileSize,hasEmbeddedArtwork,dateAdded,dateModified,isMissing,trackNumber,discNumber,year,genre,bitrate,sampleRate]);

@override
String toString() {
  return 'Track(id: $id, sourceId: $sourceId, filePath: $filePath, title: $title, artistId: $artistId, albumId: $albumId, duration: $duration, format: $format, fileSize: $fileSize, hasEmbeddedArtwork: $hasEmbeddedArtwork, dateAdded: $dateAdded, dateModified: $dateModified, isMissing: $isMissing, trackNumber: $trackNumber, discNumber: $discNumber, year: $year, genre: $genre, bitrate: $bitrate, sampleRate: $sampleRate)';
}


}

/// @nodoc
abstract mixin class _$TrackCopyWith<$Res> implements $TrackCopyWith<$Res> {
  factory _$TrackCopyWith(_Track value, $Res Function(_Track) _then) = __$TrackCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceId, String filePath, String title, String artistId, String albumId, Duration duration, String format, int fileSize, bool hasEmbeddedArtwork, DateTime dateAdded, DateTime dateModified, bool isMissing, int? trackNumber, int? discNumber, int? year, String? genre, int? bitrate, int? sampleRate
});




}
/// @nodoc
class __$TrackCopyWithImpl<$Res>
    implements _$TrackCopyWith<$Res> {
  __$TrackCopyWithImpl(this._self, this._then);

  final _Track _self;
  final $Res Function(_Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceId = null,Object? filePath = null,Object? title = null,Object? artistId = null,Object? albumId = null,Object? duration = null,Object? format = null,Object? fileSize = null,Object? hasEmbeddedArtwork = null,Object? dateAdded = null,Object? dateModified = null,Object? isMissing = null,Object? trackNumber = freezed,Object? discNumber = freezed,Object? year = freezed,Object? genre = freezed,Object? bitrate = freezed,Object? sampleRate = freezed,}) {
  return _then(_Track(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,albumId: null == albumId ? _self.albumId : albumId // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,hasEmbeddedArtwork: null == hasEmbeddedArtwork ? _self.hasEmbeddedArtwork : hasEmbeddedArtwork // ignore: cast_nullable_to_non_nullable
as bool,dateAdded: null == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as DateTime,dateModified: null == dateModified ? _self.dateModified : dateModified // ignore: cast_nullable_to_non_nullable
as DateTime,isMissing: null == isMissing ? _self.isMissing : isMissing // ignore: cast_nullable_to_non_nullable
as bool,trackNumber: freezed == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int?,discNumber: freezed == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,bitrate: freezed == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int?,sampleRate: freezed == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
