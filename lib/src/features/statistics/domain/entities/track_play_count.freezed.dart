// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_play_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackPlayCount {

 String get trackId; int get playCount;
/// Create a copy of TrackPlayCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackPlayCountCopyWith<TrackPlayCount> get copyWith => _$TrackPlayCountCopyWithImpl<TrackPlayCount>(this as TrackPlayCount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackPlayCount&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.playCount, playCount) || other.playCount == playCount));
}


@override
int get hashCode => Object.hash(runtimeType,trackId,playCount);

@override
String toString() {
  return 'TrackPlayCount(trackId: $trackId, playCount: $playCount)';
}


}

/// @nodoc
abstract mixin class $TrackPlayCountCopyWith<$Res>  {
  factory $TrackPlayCountCopyWith(TrackPlayCount value, $Res Function(TrackPlayCount) _then) = _$TrackPlayCountCopyWithImpl;
@useResult
$Res call({
 String trackId, int playCount
});




}
/// @nodoc
class _$TrackPlayCountCopyWithImpl<$Res>
    implements $TrackPlayCountCopyWith<$Res> {
  _$TrackPlayCountCopyWithImpl(this._self, this._then);

  final TrackPlayCount _self;
  final $Res Function(TrackPlayCount) _then;

/// Create a copy of TrackPlayCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackId = null,Object? playCount = null,}) {
  return _then(_self.copyWith(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackPlayCount].
extension TrackPlayCountPatterns on TrackPlayCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackPlayCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackPlayCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackPlayCount value)  $default,){
final _that = this;
switch (_that) {
case _TrackPlayCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackPlayCount value)?  $default,){
final _that = this;
switch (_that) {
case _TrackPlayCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String trackId,  int playCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackPlayCount() when $default != null:
return $default(_that.trackId,_that.playCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String trackId,  int playCount)  $default,) {final _that = this;
switch (_that) {
case _TrackPlayCount():
return $default(_that.trackId,_that.playCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String trackId,  int playCount)?  $default,) {final _that = this;
switch (_that) {
case _TrackPlayCount() when $default != null:
return $default(_that.trackId,_that.playCount);case _:
  return null;

}
}

}

/// @nodoc


class _TrackPlayCount implements TrackPlayCount {
  const _TrackPlayCount({required this.trackId, required this.playCount});
  

@override final  String trackId;
@override final  int playCount;

/// Create a copy of TrackPlayCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackPlayCountCopyWith<_TrackPlayCount> get copyWith => __$TrackPlayCountCopyWithImpl<_TrackPlayCount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackPlayCount&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.playCount, playCount) || other.playCount == playCount));
}


@override
int get hashCode => Object.hash(runtimeType,trackId,playCount);

@override
String toString() {
  return 'TrackPlayCount(trackId: $trackId, playCount: $playCount)';
}


}

/// @nodoc
abstract mixin class _$TrackPlayCountCopyWith<$Res> implements $TrackPlayCountCopyWith<$Res> {
  factory _$TrackPlayCountCopyWith(_TrackPlayCount value, $Res Function(_TrackPlayCount) _then) = __$TrackPlayCountCopyWithImpl;
@override @useResult
$Res call({
 String trackId, int playCount
});




}
/// @nodoc
class __$TrackPlayCountCopyWithImpl<$Res>
    implements _$TrackPlayCountCopyWith<$Res> {
  __$TrackPlayCountCopyWithImpl(this._self, this._then);

  final _TrackPlayCount _self;
  final $Res Function(_TrackPlayCount) _then;

/// Create a copy of TrackPlayCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackId = null,Object? playCount = null,}) {
  return _then(_TrackPlayCount(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
