// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Album {

 String get id; String get sourceId; String get title; String get artistId; int get trackCount; Duration get totalDuration; int? get year; String? get artworkPath;
/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumCopyWith<Album> get copyWith => _$AlbumCopyWithImpl<Album>(this as Album, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Album&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.year, year) || other.year == year)&&(identical(other.artworkPath, artworkPath) || other.artworkPath == artworkPath));
}


@override
int get hashCode => Object.hash(runtimeType,id,sourceId,title,artistId,trackCount,totalDuration,year,artworkPath);

@override
String toString() {
  return 'Album(id: $id, sourceId: $sourceId, title: $title, artistId: $artistId, trackCount: $trackCount, totalDuration: $totalDuration, year: $year, artworkPath: $artworkPath)';
}


}

/// @nodoc
abstract mixin class $AlbumCopyWith<$Res>  {
  factory $AlbumCopyWith(Album value, $Res Function(Album) _then) = _$AlbumCopyWithImpl;
@useResult
$Res call({
 String id, String sourceId, String title, String artistId, int trackCount, Duration totalDuration, int? year, String? artworkPath
});




}
/// @nodoc
class _$AlbumCopyWithImpl<$Res>
    implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._self, this._then);

  final Album _self;
  final $Res Function(Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceId = null,Object? title = null,Object? artistId = null,Object? trackCount = null,Object? totalDuration = null,Object? year = freezed,Object? artworkPath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,artworkPath: freezed == artworkPath ? _self.artworkPath : artworkPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Album].
extension AlbumPatterns on Album {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Album value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Album value)  $default,){
final _that = this;
switch (_that) {
case _Album():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Album value)?  $default,){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceId,  String title,  String artistId,  int trackCount,  Duration totalDuration,  int? year,  String? artworkPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that.id,_that.sourceId,_that.title,_that.artistId,_that.trackCount,_that.totalDuration,_that.year,_that.artworkPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceId,  String title,  String artistId,  int trackCount,  Duration totalDuration,  int? year,  String? artworkPath)  $default,) {final _that = this;
switch (_that) {
case _Album():
return $default(_that.id,_that.sourceId,_that.title,_that.artistId,_that.trackCount,_that.totalDuration,_that.year,_that.artworkPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceId,  String title,  String artistId,  int trackCount,  Duration totalDuration,  int? year,  String? artworkPath)?  $default,) {final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that.id,_that.sourceId,_that.title,_that.artistId,_that.trackCount,_that.totalDuration,_that.year,_that.artworkPath);case _:
  return null;

}
}

}

/// @nodoc


class _Album implements Album {
  const _Album({required this.id, required this.sourceId, required this.title, required this.artistId, required this.trackCount, required this.totalDuration, this.year, this.artworkPath});
  

@override final  String id;
@override final  String sourceId;
@override final  String title;
@override final  String artistId;
@override final  int trackCount;
@override final  Duration totalDuration;
@override final  int? year;
@override final  String? artworkPath;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumCopyWith<_Album> get copyWith => __$AlbumCopyWithImpl<_Album>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Album&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.year, year) || other.year == year)&&(identical(other.artworkPath, artworkPath) || other.artworkPath == artworkPath));
}


@override
int get hashCode => Object.hash(runtimeType,id,sourceId,title,artistId,trackCount,totalDuration,year,artworkPath);

@override
String toString() {
  return 'Album(id: $id, sourceId: $sourceId, title: $title, artistId: $artistId, trackCount: $trackCount, totalDuration: $totalDuration, year: $year, artworkPath: $artworkPath)';
}


}

/// @nodoc
abstract mixin class _$AlbumCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$AlbumCopyWith(_Album value, $Res Function(_Album) _then) = __$AlbumCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceId, String title, String artistId, int trackCount, Duration totalDuration, int? year, String? artworkPath
});




}
/// @nodoc
class __$AlbumCopyWithImpl<$Res>
    implements _$AlbumCopyWith<$Res> {
  __$AlbumCopyWithImpl(this._self, this._then);

  final _Album _self;
  final $Res Function(_Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceId = null,Object? title = null,Object? artistId = null,Object? trackCount = null,Object? totalDuration = null,Object? year = freezed,Object? artworkPath = freezed,}) {
  return _then(_Album(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,artworkPath: freezed == artworkPath ? _self.artworkPath : artworkPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
