// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lyrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Lyrics {

 String get trackId; String? get content; LyricsSource get source;
/// Create a copy of Lyrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LyricsCopyWith<Lyrics> get copyWith => _$LyricsCopyWithImpl<Lyrics>(this as Lyrics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lyrics&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.content, content) || other.content == content)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,trackId,content,source);

@override
String toString() {
  return 'Lyrics(trackId: $trackId, content: $content, source: $source)';
}


}

/// @nodoc
abstract mixin class $LyricsCopyWith<$Res>  {
  factory $LyricsCopyWith(Lyrics value, $Res Function(Lyrics) _then) = _$LyricsCopyWithImpl;
@useResult
$Res call({
 String trackId, String? content, LyricsSource source
});




}
/// @nodoc
class _$LyricsCopyWithImpl<$Res>
    implements $LyricsCopyWith<$Res> {
  _$LyricsCopyWithImpl(this._self, this._then);

  final Lyrics _self;
  final $Res Function(Lyrics) _then;

/// Create a copy of Lyrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackId = null,Object? content = freezed,Object? source = null,}) {
  return _then(_self.copyWith(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as LyricsSource,
  ));
}

}


/// Adds pattern-matching-related methods to [Lyrics].
extension LyricsPatterns on Lyrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lyrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lyrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lyrics value)  $default,){
final _that = this;
switch (_that) {
case _Lyrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lyrics value)?  $default,){
final _that = this;
switch (_that) {
case _Lyrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String trackId,  String? content,  LyricsSource source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lyrics() when $default != null:
return $default(_that.trackId,_that.content,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String trackId,  String? content,  LyricsSource source)  $default,) {final _that = this;
switch (_that) {
case _Lyrics():
return $default(_that.trackId,_that.content,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String trackId,  String? content,  LyricsSource source)?  $default,) {final _that = this;
switch (_that) {
case _Lyrics() when $default != null:
return $default(_that.trackId,_that.content,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _Lyrics implements Lyrics {
  const _Lyrics({required this.trackId, required this.content, required this.source});
  

@override final  String trackId;
@override final  String? content;
@override final  LyricsSource source;

/// Create a copy of Lyrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LyricsCopyWith<_Lyrics> get copyWith => __$LyricsCopyWithImpl<_Lyrics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lyrics&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.content, content) || other.content == content)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,trackId,content,source);

@override
String toString() {
  return 'Lyrics(trackId: $trackId, content: $content, source: $source)';
}


}

/// @nodoc
abstract mixin class _$LyricsCopyWith<$Res> implements $LyricsCopyWith<$Res> {
  factory _$LyricsCopyWith(_Lyrics value, $Res Function(_Lyrics) _then) = __$LyricsCopyWithImpl;
@override @useResult
$Res call({
 String trackId, String? content, LyricsSource source
});




}
/// @nodoc
class __$LyricsCopyWithImpl<$Res>
    implements _$LyricsCopyWith<$Res> {
  __$LyricsCopyWithImpl(this._self, this._then);

  final _Lyrics _self;
  final $Res Function(_Lyrics) _then;

/// Create a copy of Lyrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackId = null,Object? content = freezed,Object? source = null,}) {
  return _then(_Lyrics(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as LyricsSource,
  ));
}


}

// dart format on
