// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'folder_usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FolderUsage {

 String get path; int get sizeBytes; int get trackCount;
/// Create a copy of FolderUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderUsageCopyWith<FolderUsage> get copyWith => _$FolderUsageCopyWithImpl<FolderUsage>(this as FolderUsage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderUsage&&(identical(other.path, path) || other.path == path)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount));
}


@override
int get hashCode => Object.hash(runtimeType,path,sizeBytes,trackCount);

@override
String toString() {
  return 'FolderUsage(path: $path, sizeBytes: $sizeBytes, trackCount: $trackCount)';
}


}

/// @nodoc
abstract mixin class $FolderUsageCopyWith<$Res>  {
  factory $FolderUsageCopyWith(FolderUsage value, $Res Function(FolderUsage) _then) = _$FolderUsageCopyWithImpl;
@useResult
$Res call({
 String path, int sizeBytes, int trackCount
});




}
/// @nodoc
class _$FolderUsageCopyWithImpl<$Res>
    implements $FolderUsageCopyWith<$Res> {
  _$FolderUsageCopyWithImpl(this._self, this._then);

  final FolderUsage _self;
  final $Res Function(FolderUsage) _then;

/// Create a copy of FolderUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? sizeBytes = null,Object? trackCount = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FolderUsage].
extension FolderUsagePatterns on FolderUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FolderUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FolderUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FolderUsage value)  $default,){
final _that = this;
switch (_that) {
case _FolderUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FolderUsage value)?  $default,){
final _that = this;
switch (_that) {
case _FolderUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  int sizeBytes,  int trackCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FolderUsage() when $default != null:
return $default(_that.path,_that.sizeBytes,_that.trackCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  int sizeBytes,  int trackCount)  $default,) {final _that = this;
switch (_that) {
case _FolderUsage():
return $default(_that.path,_that.sizeBytes,_that.trackCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  int sizeBytes,  int trackCount)?  $default,) {final _that = this;
switch (_that) {
case _FolderUsage() when $default != null:
return $default(_that.path,_that.sizeBytes,_that.trackCount);case _:
  return null;

}
}

}

/// @nodoc


class _FolderUsage implements FolderUsage {
  const _FolderUsage({required this.path, required this.sizeBytes, required this.trackCount});
  

@override final  String path;
@override final  int sizeBytes;
@override final  int trackCount;

/// Create a copy of FolderUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FolderUsageCopyWith<_FolderUsage> get copyWith => __$FolderUsageCopyWithImpl<_FolderUsage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FolderUsage&&(identical(other.path, path) || other.path == path)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount));
}


@override
int get hashCode => Object.hash(runtimeType,path,sizeBytes,trackCount);

@override
String toString() {
  return 'FolderUsage(path: $path, sizeBytes: $sizeBytes, trackCount: $trackCount)';
}


}

/// @nodoc
abstract mixin class _$FolderUsageCopyWith<$Res> implements $FolderUsageCopyWith<$Res> {
  factory _$FolderUsageCopyWith(_FolderUsage value, $Res Function(_FolderUsage) _then) = __$FolderUsageCopyWithImpl;
@override @useResult
$Res call({
 String path, int sizeBytes, int trackCount
});




}
/// @nodoc
class __$FolderUsageCopyWithImpl<$Res>
    implements _$FolderUsageCopyWith<$Res> {
  __$FolderUsageCopyWithImpl(this._self, this._then);

  final _FolderUsage _self;
  final $Res Function(_FolderUsage) _then;

/// Create a copy of FolderUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? sizeBytes = null,Object? trackCount = null,}) {
  return _then(_FolderUsage(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
