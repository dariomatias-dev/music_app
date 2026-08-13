// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaybackState {

 AudioProcessingState get processingState; bool get playing; Duration get position; Duration? get duration; Duration get bufferedPosition; double get speed; int? get currentIndex; int get queueLength; AudioLoopMode get loopMode; bool get shuffleModeEnabled;
/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackStateCopyWith<PlaybackState> get copyWith => _$PlaybackStateCopyWithImpl<PlaybackState>(this as PlaybackState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackState&&(identical(other.processingState, processingState) || other.processingState == processingState)&&(identical(other.playing, playing) || other.playing == playing)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.bufferedPosition, bufferedPosition) || other.bufferedPosition == bufferedPosition)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.queueLength, queueLength) || other.queueLength == queueLength)&&(identical(other.loopMode, loopMode) || other.loopMode == loopMode)&&(identical(other.shuffleModeEnabled, shuffleModeEnabled) || other.shuffleModeEnabled == shuffleModeEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,processingState,playing,position,duration,bufferedPosition,speed,currentIndex,queueLength,loopMode,shuffleModeEnabled);

@override
String toString() {
  return 'PlaybackState(processingState: $processingState, playing: $playing, position: $position, duration: $duration, bufferedPosition: $bufferedPosition, speed: $speed, currentIndex: $currentIndex, queueLength: $queueLength, loopMode: $loopMode, shuffleModeEnabled: $shuffleModeEnabled)';
}


}

/// @nodoc
abstract mixin class $PlaybackStateCopyWith<$Res>  {
  factory $PlaybackStateCopyWith(PlaybackState value, $Res Function(PlaybackState) _then) = _$PlaybackStateCopyWithImpl;
@useResult
$Res call({
 AudioProcessingState processingState, bool playing, Duration position, Duration? duration, Duration bufferedPosition, double speed, int? currentIndex, int queueLength, AudioLoopMode loopMode, bool shuffleModeEnabled
});




}
/// @nodoc
class _$PlaybackStateCopyWithImpl<$Res>
    implements $PlaybackStateCopyWith<$Res> {
  _$PlaybackStateCopyWithImpl(this._self, this._then);

  final PlaybackState _self;
  final $Res Function(PlaybackState) _then;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? processingState = null,Object? playing = null,Object? position = null,Object? duration = freezed,Object? bufferedPosition = null,Object? speed = null,Object? currentIndex = freezed,Object? queueLength = null,Object? loopMode = null,Object? shuffleModeEnabled = null,}) {
  return _then(_self.copyWith(
processingState: null == processingState ? _self.processingState : processingState // ignore: cast_nullable_to_non_nullable
as AudioProcessingState,playing: null == playing ? _self.playing : playing // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,bufferedPosition: null == bufferedPosition ? _self.bufferedPosition : bufferedPosition // ignore: cast_nullable_to_non_nullable
as Duration,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,currentIndex: freezed == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int?,queueLength: null == queueLength ? _self.queueLength : queueLength // ignore: cast_nullable_to_non_nullable
as int,loopMode: null == loopMode ? _self.loopMode : loopMode // ignore: cast_nullable_to_non_nullable
as AudioLoopMode,shuffleModeEnabled: null == shuffleModeEnabled ? _self.shuffleModeEnabled : shuffleModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaybackState].
extension PlaybackStatePatterns on PlaybackState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackState value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackState value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AudioProcessingState processingState,  bool playing,  Duration position,  Duration? duration,  Duration bufferedPosition,  double speed,  int? currentIndex,  int queueLength,  AudioLoopMode loopMode,  bool shuffleModeEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that.processingState,_that.playing,_that.position,_that.duration,_that.bufferedPosition,_that.speed,_that.currentIndex,_that.queueLength,_that.loopMode,_that.shuffleModeEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AudioProcessingState processingState,  bool playing,  Duration position,  Duration? duration,  Duration bufferedPosition,  double speed,  int? currentIndex,  int queueLength,  AudioLoopMode loopMode,  bool shuffleModeEnabled)  $default,) {final _that = this;
switch (_that) {
case _PlaybackState():
return $default(_that.processingState,_that.playing,_that.position,_that.duration,_that.bufferedPosition,_that.speed,_that.currentIndex,_that.queueLength,_that.loopMode,_that.shuffleModeEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AudioProcessingState processingState,  bool playing,  Duration position,  Duration? duration,  Duration bufferedPosition,  double speed,  int? currentIndex,  int queueLength,  AudioLoopMode loopMode,  bool shuffleModeEnabled)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that.processingState,_that.playing,_that.position,_that.duration,_that.bufferedPosition,_that.speed,_that.currentIndex,_that.queueLength,_that.loopMode,_that.shuffleModeEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _PlaybackState implements PlaybackState {
  const _PlaybackState({required this.processingState, required this.playing, required this.position, required this.duration, required this.bufferedPosition, required this.speed, required this.currentIndex, required this.queueLength, required this.loopMode, required this.shuffleModeEnabled});
  

@override final  AudioProcessingState processingState;
@override final  bool playing;
@override final  Duration position;
@override final  Duration? duration;
@override final  Duration bufferedPosition;
@override final  double speed;
@override final  int? currentIndex;
@override final  int queueLength;
@override final  AudioLoopMode loopMode;
@override final  bool shuffleModeEnabled;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackStateCopyWith<_PlaybackState> get copyWith => __$PlaybackStateCopyWithImpl<_PlaybackState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackState&&(identical(other.processingState, processingState) || other.processingState == processingState)&&(identical(other.playing, playing) || other.playing == playing)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.bufferedPosition, bufferedPosition) || other.bufferedPosition == bufferedPosition)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.queueLength, queueLength) || other.queueLength == queueLength)&&(identical(other.loopMode, loopMode) || other.loopMode == loopMode)&&(identical(other.shuffleModeEnabled, shuffleModeEnabled) || other.shuffleModeEnabled == shuffleModeEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,processingState,playing,position,duration,bufferedPosition,speed,currentIndex,queueLength,loopMode,shuffleModeEnabled);

@override
String toString() {
  return 'PlaybackState(processingState: $processingState, playing: $playing, position: $position, duration: $duration, bufferedPosition: $bufferedPosition, speed: $speed, currentIndex: $currentIndex, queueLength: $queueLength, loopMode: $loopMode, shuffleModeEnabled: $shuffleModeEnabled)';
}


}

/// @nodoc
abstract mixin class _$PlaybackStateCopyWith<$Res> implements $PlaybackStateCopyWith<$Res> {
  factory _$PlaybackStateCopyWith(_PlaybackState value, $Res Function(_PlaybackState) _then) = __$PlaybackStateCopyWithImpl;
@override @useResult
$Res call({
 AudioProcessingState processingState, bool playing, Duration position, Duration? duration, Duration bufferedPosition, double speed, int? currentIndex, int queueLength, AudioLoopMode loopMode, bool shuffleModeEnabled
});




}
/// @nodoc
class __$PlaybackStateCopyWithImpl<$Res>
    implements _$PlaybackStateCopyWith<$Res> {
  __$PlaybackStateCopyWithImpl(this._self, this._then);

  final _PlaybackState _self;
  final $Res Function(_PlaybackState) _then;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? processingState = null,Object? playing = null,Object? position = null,Object? duration = freezed,Object? bufferedPosition = null,Object? speed = null,Object? currentIndex = freezed,Object? queueLength = null,Object? loopMode = null,Object? shuffleModeEnabled = null,}) {
  return _then(_PlaybackState(
processingState: null == processingState ? _self.processingState : processingState // ignore: cast_nullable_to_non_nullable
as AudioProcessingState,playing: null == playing ? _self.playing : playing // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,bufferedPosition: null == bufferedPosition ? _self.bufferedPosition : bufferedPosition // ignore: cast_nullable_to_non_nullable
as Duration,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,currentIndex: freezed == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int?,queueLength: null == queueLength ? _self.queueLength : queueLength // ignore: cast_nullable_to_non_nullable
as int,loopMode: null == loopMode ? _self.loopMode : loopMode // ignore: cast_nullable_to_non_nullable
as AudioLoopMode,shuffleModeEnabled: null == shuffleModeEnabled ? _self.shuffleModeEnabled : shuffleModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
