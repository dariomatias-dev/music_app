// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaybackPreferences {

/// Whether tracks advance into each other with no silence between them.
/// Only relevant when [crossfadeDuration] is zero.
 bool get gaplessEnabled;/// How long each track fades in from silence when it starts. Zero
/// means no crossfade.
 Duration get crossfadeDuration;/// Playback speed applied whenever a new queue starts playing.
 double get defaultSpeed;/// Whether playback controls give haptic feedback when tapped.
 bool get hapticsEnabled;
/// Create a copy of PlaybackPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackPreferencesCopyWith<PlaybackPreferences> get copyWith => _$PlaybackPreferencesCopyWithImpl<PlaybackPreferences>(this as PlaybackPreferences, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackPreferences&&(identical(other.gaplessEnabled, gaplessEnabled) || other.gaplessEnabled == gaplessEnabled)&&(identical(other.crossfadeDuration, crossfadeDuration) || other.crossfadeDuration == crossfadeDuration)&&(identical(other.defaultSpeed, defaultSpeed) || other.defaultSpeed == defaultSpeed)&&(identical(other.hapticsEnabled, hapticsEnabled) || other.hapticsEnabled == hapticsEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,gaplessEnabled,crossfadeDuration,defaultSpeed,hapticsEnabled);

@override
String toString() {
  return 'PlaybackPreferences(gaplessEnabled: $gaplessEnabled, crossfadeDuration: $crossfadeDuration, defaultSpeed: $defaultSpeed, hapticsEnabled: $hapticsEnabled)';
}


}

/// @nodoc
abstract mixin class $PlaybackPreferencesCopyWith<$Res>  {
  factory $PlaybackPreferencesCopyWith(PlaybackPreferences value, $Res Function(PlaybackPreferences) _then) = _$PlaybackPreferencesCopyWithImpl;
@useResult
$Res call({
 bool gaplessEnabled, Duration crossfadeDuration, double defaultSpeed, bool hapticsEnabled
});




}
/// @nodoc
class _$PlaybackPreferencesCopyWithImpl<$Res>
    implements $PlaybackPreferencesCopyWith<$Res> {
  _$PlaybackPreferencesCopyWithImpl(this._self, this._then);

  final PlaybackPreferences _self;
  final $Res Function(PlaybackPreferences) _then;

/// Create a copy of PlaybackPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gaplessEnabled = null,Object? crossfadeDuration = null,Object? defaultSpeed = null,Object? hapticsEnabled = null,}) {
  return _then(_self.copyWith(
gaplessEnabled: null == gaplessEnabled ? _self.gaplessEnabled : gaplessEnabled // ignore: cast_nullable_to_non_nullable
as bool,crossfadeDuration: null == crossfadeDuration ? _self.crossfadeDuration : crossfadeDuration // ignore: cast_nullable_to_non_nullable
as Duration,defaultSpeed: null == defaultSpeed ? _self.defaultSpeed : defaultSpeed // ignore: cast_nullable_to_non_nullable
as double,hapticsEnabled: null == hapticsEnabled ? _self.hapticsEnabled : hapticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaybackPreferences].
extension PlaybackPreferencesPatterns on PlaybackPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackPreferences value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool gaplessEnabled,  Duration crossfadeDuration,  double defaultSpeed,  bool hapticsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackPreferences() when $default != null:
return $default(_that.gaplessEnabled,_that.crossfadeDuration,_that.defaultSpeed,_that.hapticsEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool gaplessEnabled,  Duration crossfadeDuration,  double defaultSpeed,  bool hapticsEnabled)  $default,) {final _that = this;
switch (_that) {
case _PlaybackPreferences():
return $default(_that.gaplessEnabled,_that.crossfadeDuration,_that.defaultSpeed,_that.hapticsEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool gaplessEnabled,  Duration crossfadeDuration,  double defaultSpeed,  bool hapticsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackPreferences() when $default != null:
return $default(_that.gaplessEnabled,_that.crossfadeDuration,_that.defaultSpeed,_that.hapticsEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _PlaybackPreferences implements PlaybackPreferences {
  const _PlaybackPreferences({this.gaplessEnabled = true, this.crossfadeDuration = Duration.zero, this.defaultSpeed = 1.0, this.hapticsEnabled = true});
  

/// Whether tracks advance into each other with no silence between them.
/// Only relevant when [crossfadeDuration] is zero.
@override@JsonKey() final  bool gaplessEnabled;
/// How long each track fades in from silence when it starts. Zero
/// means no crossfade.
@override@JsonKey() final  Duration crossfadeDuration;
/// Playback speed applied whenever a new queue starts playing.
@override@JsonKey() final  double defaultSpeed;
/// Whether playback controls give haptic feedback when tapped.
@override@JsonKey() final  bool hapticsEnabled;

/// Create a copy of PlaybackPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackPreferencesCopyWith<_PlaybackPreferences> get copyWith => __$PlaybackPreferencesCopyWithImpl<_PlaybackPreferences>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackPreferences&&(identical(other.gaplessEnabled, gaplessEnabled) || other.gaplessEnabled == gaplessEnabled)&&(identical(other.crossfadeDuration, crossfadeDuration) || other.crossfadeDuration == crossfadeDuration)&&(identical(other.defaultSpeed, defaultSpeed) || other.defaultSpeed == defaultSpeed)&&(identical(other.hapticsEnabled, hapticsEnabled) || other.hapticsEnabled == hapticsEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,gaplessEnabled,crossfadeDuration,defaultSpeed,hapticsEnabled);

@override
String toString() {
  return 'PlaybackPreferences(gaplessEnabled: $gaplessEnabled, crossfadeDuration: $crossfadeDuration, defaultSpeed: $defaultSpeed, hapticsEnabled: $hapticsEnabled)';
}


}

/// @nodoc
abstract mixin class _$PlaybackPreferencesCopyWith<$Res> implements $PlaybackPreferencesCopyWith<$Res> {
  factory _$PlaybackPreferencesCopyWith(_PlaybackPreferences value, $Res Function(_PlaybackPreferences) _then) = __$PlaybackPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool gaplessEnabled, Duration crossfadeDuration, double defaultSpeed, bool hapticsEnabled
});




}
/// @nodoc
class __$PlaybackPreferencesCopyWithImpl<$Res>
    implements _$PlaybackPreferencesCopyWith<$Res> {
  __$PlaybackPreferencesCopyWithImpl(this._self, this._then);

  final _PlaybackPreferences _self;
  final $Res Function(_PlaybackPreferences) _then;

/// Create a copy of PlaybackPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gaplessEnabled = null,Object? crossfadeDuration = null,Object? defaultSpeed = null,Object? hapticsEnabled = null,}) {
  return _then(_PlaybackPreferences(
gaplessEnabled: null == gaplessEnabled ? _self.gaplessEnabled : gaplessEnabled // ignore: cast_nullable_to_non_nullable
as bool,crossfadeDuration: null == crossfadeDuration ? _self.crossfadeDuration : crossfadeDuration // ignore: cast_nullable_to_non_nullable
as Duration,defaultSpeed: null == defaultSpeed ? _self.defaultSpeed : defaultSpeed // ignore: cast_nullable_to_non_nullable
as double,hapticsEnabled: null == hapticsEnabled ? _self.hapticsEnabled : hapticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
