// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_play_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyPlayCount {

 DateTime get date; int get playCount;
/// Create a copy of DailyPlayCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyPlayCountCopyWith<DailyPlayCount> get copyWith => _$DailyPlayCountCopyWithImpl<DailyPlayCount>(this as DailyPlayCount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyPlayCount&&(identical(other.date, date) || other.date == date)&&(identical(other.playCount, playCount) || other.playCount == playCount));
}


@override
int get hashCode => Object.hash(runtimeType,date,playCount);

@override
String toString() {
  return 'DailyPlayCount(date: $date, playCount: $playCount)';
}


}

/// @nodoc
abstract mixin class $DailyPlayCountCopyWith<$Res>  {
  factory $DailyPlayCountCopyWith(DailyPlayCount value, $Res Function(DailyPlayCount) _then) = _$DailyPlayCountCopyWithImpl;
@useResult
$Res call({
 DateTime date, int playCount
});




}
/// @nodoc
class _$DailyPlayCountCopyWithImpl<$Res>
    implements $DailyPlayCountCopyWith<$Res> {
  _$DailyPlayCountCopyWithImpl(this._self, this._then);

  final DailyPlayCount _self;
  final $Res Function(DailyPlayCount) _then;

/// Create a copy of DailyPlayCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? playCount = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyPlayCount].
extension DailyPlayCountPatterns on DailyPlayCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyPlayCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyPlayCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyPlayCount value)  $default,){
final _that = this;
switch (_that) {
case _DailyPlayCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyPlayCount value)?  $default,){
final _that = this;
switch (_that) {
case _DailyPlayCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int playCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyPlayCount() when $default != null:
return $default(_that.date,_that.playCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int playCount)  $default,) {final _that = this;
switch (_that) {
case _DailyPlayCount():
return $default(_that.date,_that.playCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int playCount)?  $default,) {final _that = this;
switch (_that) {
case _DailyPlayCount() when $default != null:
return $default(_that.date,_that.playCount);case _:
  return null;

}
}

}

/// @nodoc


class _DailyPlayCount implements DailyPlayCount {
  const _DailyPlayCount({required this.date, required this.playCount});
  

@override final  DateTime date;
@override final  int playCount;

/// Create a copy of DailyPlayCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyPlayCountCopyWith<_DailyPlayCount> get copyWith => __$DailyPlayCountCopyWithImpl<_DailyPlayCount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyPlayCount&&(identical(other.date, date) || other.date == date)&&(identical(other.playCount, playCount) || other.playCount == playCount));
}


@override
int get hashCode => Object.hash(runtimeType,date,playCount);

@override
String toString() {
  return 'DailyPlayCount(date: $date, playCount: $playCount)';
}


}

/// @nodoc
abstract mixin class _$DailyPlayCountCopyWith<$Res> implements $DailyPlayCountCopyWith<$Res> {
  factory _$DailyPlayCountCopyWith(_DailyPlayCount value, $Res Function(_DailyPlayCount) _then) = __$DailyPlayCountCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int playCount
});




}
/// @nodoc
class __$DailyPlayCountCopyWithImpl<$Res>
    implements _$DailyPlayCountCopyWith<$Res> {
  __$DailyPlayCountCopyWithImpl(this._self, this._then);

  final _DailyPlayCount _self;
  final $Res Function(_DailyPlayCount) _then;

/// Create a copy of DailyPlayCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? playCount = null,}) {
  return _then(_DailyPlayCount(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
