// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_playlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupPlaylist {

 String get name; bool get isFavorite; List<String> get trackSourceIds; String? get description;
/// Create a copy of BackupPlaylist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupPlaylistCopyWith<BackupPlaylist> get copyWith => _$BackupPlaylistCopyWithImpl<BackupPlaylist>(this as BackupPlaylist, _$identity);

  /// Serializes this BackupPlaylist to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupPlaylist&&(identical(other.name, name) || other.name == name)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&const DeepCollectionEquality().equals(other.trackSourceIds, trackSourceIds)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,isFavorite,const DeepCollectionEquality().hash(trackSourceIds),description);

@override
String toString() {
  return 'BackupPlaylist(name: $name, isFavorite: $isFavorite, trackSourceIds: $trackSourceIds, description: $description)';
}


}

/// @nodoc
abstract mixin class $BackupPlaylistCopyWith<$Res>  {
  factory $BackupPlaylistCopyWith(BackupPlaylist value, $Res Function(BackupPlaylist) _then) = _$BackupPlaylistCopyWithImpl;
@useResult
$Res call({
 String name, bool isFavorite, List<String> trackSourceIds, String? description
});




}
/// @nodoc
class _$BackupPlaylistCopyWithImpl<$Res>
    implements $BackupPlaylistCopyWith<$Res> {
  _$BackupPlaylistCopyWithImpl(this._self, this._then);

  final BackupPlaylist _self;
  final $Res Function(BackupPlaylist) _then;

/// Create a copy of BackupPlaylist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? isFavorite = null,Object? trackSourceIds = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,trackSourceIds: null == trackSourceIds ? _self.trackSourceIds : trackSourceIds // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupPlaylist].
extension BackupPlaylistPatterns on BackupPlaylist {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupPlaylist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupPlaylist() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupPlaylist value)  $default,){
final _that = this;
switch (_that) {
case _BackupPlaylist():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupPlaylist value)?  $default,){
final _that = this;
switch (_that) {
case _BackupPlaylist() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool isFavorite,  List<String> trackSourceIds,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupPlaylist() when $default != null:
return $default(_that.name,_that.isFavorite,_that.trackSourceIds,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool isFavorite,  List<String> trackSourceIds,  String? description)  $default,) {final _that = this;
switch (_that) {
case _BackupPlaylist():
return $default(_that.name,_that.isFavorite,_that.trackSourceIds,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool isFavorite,  List<String> trackSourceIds,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _BackupPlaylist() when $default != null:
return $default(_that.name,_that.isFavorite,_that.trackSourceIds,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupPlaylist implements BackupPlaylist {
  const _BackupPlaylist({required this.name, required this.isFavorite, required final  List<String> trackSourceIds, this.description}): _trackSourceIds = trackSourceIds;
  factory _BackupPlaylist.fromJson(Map<String, dynamic> json) => _$BackupPlaylistFromJson(json);

@override final  String name;
@override final  bool isFavorite;
 final  List<String> _trackSourceIds;
@override List<String> get trackSourceIds {
  if (_trackSourceIds is EqualUnmodifiableListView) return _trackSourceIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trackSourceIds);
}

@override final  String? description;

/// Create a copy of BackupPlaylist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupPlaylistCopyWith<_BackupPlaylist> get copyWith => __$BackupPlaylistCopyWithImpl<_BackupPlaylist>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupPlaylistToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupPlaylist&&(identical(other.name, name) || other.name == name)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&const DeepCollectionEquality().equals(other._trackSourceIds, _trackSourceIds)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,isFavorite,const DeepCollectionEquality().hash(_trackSourceIds),description);

@override
String toString() {
  return 'BackupPlaylist(name: $name, isFavorite: $isFavorite, trackSourceIds: $trackSourceIds, description: $description)';
}


}

/// @nodoc
abstract mixin class _$BackupPlaylistCopyWith<$Res> implements $BackupPlaylistCopyWith<$Res> {
  factory _$BackupPlaylistCopyWith(_BackupPlaylist value, $Res Function(_BackupPlaylist) _then) = __$BackupPlaylistCopyWithImpl;
@override @useResult
$Res call({
 String name, bool isFavorite, List<String> trackSourceIds, String? description
});




}
/// @nodoc
class __$BackupPlaylistCopyWithImpl<$Res>
    implements _$BackupPlaylistCopyWith<$Res> {
  __$BackupPlaylistCopyWithImpl(this._self, this._then);

  final _BackupPlaylist _self;
  final $Res Function(_BackupPlaylist) _then;

/// Create a copy of BackupPlaylist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? isFavorite = null,Object? trackSourceIds = null,Object? description = freezed,}) {
  return _then(_BackupPlaylist(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,trackSourceIds: null == trackSourceIds ? _self._trackSourceIds : trackSourceIds // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
