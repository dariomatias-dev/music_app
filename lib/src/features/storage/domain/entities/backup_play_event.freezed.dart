// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_play_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupPlayEvent {

 String get trackSourceId; DateTime get startedAt; int get playedDurationMs; bool get completed;
/// Create a copy of BackupPlayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupPlayEventCopyWith<BackupPlayEvent> get copyWith => _$BackupPlayEventCopyWithImpl<BackupPlayEvent>(this as BackupPlayEvent, _$identity);

  /// Serializes this BackupPlayEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupPlayEvent&&(identical(other.trackSourceId, trackSourceId) || other.trackSourceId == trackSourceId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.playedDurationMs, playedDurationMs) || other.playedDurationMs == playedDurationMs)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trackSourceId,startedAt,playedDurationMs,completed);

@override
String toString() {
  return 'BackupPlayEvent(trackSourceId: $trackSourceId, startedAt: $startedAt, playedDurationMs: $playedDurationMs, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $BackupPlayEventCopyWith<$Res>  {
  factory $BackupPlayEventCopyWith(BackupPlayEvent value, $Res Function(BackupPlayEvent) _then) = _$BackupPlayEventCopyWithImpl;
@useResult
$Res call({
 String trackSourceId, DateTime startedAt, int playedDurationMs, bool completed
});




}
/// @nodoc
class _$BackupPlayEventCopyWithImpl<$Res>
    implements $BackupPlayEventCopyWith<$Res> {
  _$BackupPlayEventCopyWithImpl(this._self, this._then);

  final BackupPlayEvent _self;
  final $Res Function(BackupPlayEvent) _then;

/// Create a copy of BackupPlayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackSourceId = null,Object? startedAt = null,Object? playedDurationMs = null,Object? completed = null,}) {
  return _then(_self.copyWith(
trackSourceId: null == trackSourceId ? _self.trackSourceId : trackSourceId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,playedDurationMs: null == playedDurationMs ? _self.playedDurationMs : playedDurationMs // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupPlayEvent].
extension BackupPlayEventPatterns on BackupPlayEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupPlayEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupPlayEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupPlayEvent value)  $default,){
final _that = this;
switch (_that) {
case _BackupPlayEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupPlayEvent value)?  $default,){
final _that = this;
switch (_that) {
case _BackupPlayEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String trackSourceId,  DateTime startedAt,  int playedDurationMs,  bool completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupPlayEvent() when $default != null:
return $default(_that.trackSourceId,_that.startedAt,_that.playedDurationMs,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String trackSourceId,  DateTime startedAt,  int playedDurationMs,  bool completed)  $default,) {final _that = this;
switch (_that) {
case _BackupPlayEvent():
return $default(_that.trackSourceId,_that.startedAt,_that.playedDurationMs,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String trackSourceId,  DateTime startedAt,  int playedDurationMs,  bool completed)?  $default,) {final _that = this;
switch (_that) {
case _BackupPlayEvent() when $default != null:
return $default(_that.trackSourceId,_that.startedAt,_that.playedDurationMs,_that.completed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupPlayEvent implements BackupPlayEvent {
  const _BackupPlayEvent({required this.trackSourceId, required this.startedAt, required this.playedDurationMs, required this.completed});
  factory _BackupPlayEvent.fromJson(Map<String, dynamic> json) => _$BackupPlayEventFromJson(json);

@override final  String trackSourceId;
@override final  DateTime startedAt;
@override final  int playedDurationMs;
@override final  bool completed;

/// Create a copy of BackupPlayEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupPlayEventCopyWith<_BackupPlayEvent> get copyWith => __$BackupPlayEventCopyWithImpl<_BackupPlayEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupPlayEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupPlayEvent&&(identical(other.trackSourceId, trackSourceId) || other.trackSourceId == trackSourceId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.playedDurationMs, playedDurationMs) || other.playedDurationMs == playedDurationMs)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trackSourceId,startedAt,playedDurationMs,completed);

@override
String toString() {
  return 'BackupPlayEvent(trackSourceId: $trackSourceId, startedAt: $startedAt, playedDurationMs: $playedDurationMs, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$BackupPlayEventCopyWith<$Res> implements $BackupPlayEventCopyWith<$Res> {
  factory _$BackupPlayEventCopyWith(_BackupPlayEvent value, $Res Function(_BackupPlayEvent) _then) = __$BackupPlayEventCopyWithImpl;
@override @useResult
$Res call({
 String trackSourceId, DateTime startedAt, int playedDurationMs, bool completed
});




}
/// @nodoc
class __$BackupPlayEventCopyWithImpl<$Res>
    implements _$BackupPlayEventCopyWith<$Res> {
  __$BackupPlayEventCopyWithImpl(this._self, this._then);

  final _BackupPlayEvent _self;
  final $Res Function(_BackupPlayEvent) _then;

/// Create a copy of BackupPlayEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackSourceId = null,Object? startedAt = null,Object? playedDurationMs = null,Object? completed = null,}) {
  return _then(_BackupPlayEvent(
trackSourceId: null == trackSourceId ? _self.trackSourceId : trackSourceId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,playedDurationMs: null == playedDurationMs ? _self.playedDurationMs : playedDurationMs // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
