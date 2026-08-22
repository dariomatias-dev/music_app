// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupSettings {

 bool get gaplessEnabled; int get crossfadeDurationSeconds; double get defaultPlaybackSpeed; bool get hapticsEnabled; String? get locale; String? get themeMode; String? get userDisplayName;
/// Create a copy of BackupSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupSettingsCopyWith<BackupSettings> get copyWith => _$BackupSettingsCopyWithImpl<BackupSettings>(this as BackupSettings, _$identity);

  /// Serializes this BackupSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupSettings&&(identical(other.gaplessEnabled, gaplessEnabled) || other.gaplessEnabled == gaplessEnabled)&&(identical(other.crossfadeDurationSeconds, crossfadeDurationSeconds) || other.crossfadeDurationSeconds == crossfadeDurationSeconds)&&(identical(other.defaultPlaybackSpeed, defaultPlaybackSpeed) || other.defaultPlaybackSpeed == defaultPlaybackSpeed)&&(identical(other.hapticsEnabled, hapticsEnabled) || other.hapticsEnabled == hapticsEnabled)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.userDisplayName, userDisplayName) || other.userDisplayName == userDisplayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gaplessEnabled,crossfadeDurationSeconds,defaultPlaybackSpeed,hapticsEnabled,locale,themeMode,userDisplayName);

@override
String toString() {
  return 'BackupSettings(gaplessEnabled: $gaplessEnabled, crossfadeDurationSeconds: $crossfadeDurationSeconds, defaultPlaybackSpeed: $defaultPlaybackSpeed, hapticsEnabled: $hapticsEnabled, locale: $locale, themeMode: $themeMode, userDisplayName: $userDisplayName)';
}


}

/// @nodoc
abstract mixin class $BackupSettingsCopyWith<$Res>  {
  factory $BackupSettingsCopyWith(BackupSettings value, $Res Function(BackupSettings) _then) = _$BackupSettingsCopyWithImpl;
@useResult
$Res call({
 bool gaplessEnabled, int crossfadeDurationSeconds, double defaultPlaybackSpeed, bool hapticsEnabled, String? locale, String? themeMode, String? userDisplayName
});




}
/// @nodoc
class _$BackupSettingsCopyWithImpl<$Res>
    implements $BackupSettingsCopyWith<$Res> {
  _$BackupSettingsCopyWithImpl(this._self, this._then);

  final BackupSettings _self;
  final $Res Function(BackupSettings) _then;

/// Create a copy of BackupSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gaplessEnabled = null,Object? crossfadeDurationSeconds = null,Object? defaultPlaybackSpeed = null,Object? hapticsEnabled = null,Object? locale = freezed,Object? themeMode = freezed,Object? userDisplayName = freezed,}) {
  return _then(_self.copyWith(
gaplessEnabled: null == gaplessEnabled ? _self.gaplessEnabled : gaplessEnabled // ignore: cast_nullable_to_non_nullable
as bool,crossfadeDurationSeconds: null == crossfadeDurationSeconds ? _self.crossfadeDurationSeconds : crossfadeDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,defaultPlaybackSpeed: null == defaultPlaybackSpeed ? _self.defaultPlaybackSpeed : defaultPlaybackSpeed // ignore: cast_nullable_to_non_nullable
as double,hapticsEnabled: null == hapticsEnabled ? _self.hapticsEnabled : hapticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,themeMode: freezed == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String?,userDisplayName: freezed == userDisplayName ? _self.userDisplayName : userDisplayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupSettings].
extension BackupSettingsPatterns on BackupSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupSettings value)  $default,){
final _that = this;
switch (_that) {
case _BackupSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupSettings value)?  $default,){
final _that = this;
switch (_that) {
case _BackupSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool gaplessEnabled,  int crossfadeDurationSeconds,  double defaultPlaybackSpeed,  bool hapticsEnabled,  String? locale,  String? themeMode,  String? userDisplayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupSettings() when $default != null:
return $default(_that.gaplessEnabled,_that.crossfadeDurationSeconds,_that.defaultPlaybackSpeed,_that.hapticsEnabled,_that.locale,_that.themeMode,_that.userDisplayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool gaplessEnabled,  int crossfadeDurationSeconds,  double defaultPlaybackSpeed,  bool hapticsEnabled,  String? locale,  String? themeMode,  String? userDisplayName)  $default,) {final _that = this;
switch (_that) {
case _BackupSettings():
return $default(_that.gaplessEnabled,_that.crossfadeDurationSeconds,_that.defaultPlaybackSpeed,_that.hapticsEnabled,_that.locale,_that.themeMode,_that.userDisplayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool gaplessEnabled,  int crossfadeDurationSeconds,  double defaultPlaybackSpeed,  bool hapticsEnabled,  String? locale,  String? themeMode,  String? userDisplayName)?  $default,) {final _that = this;
switch (_that) {
case _BackupSettings() when $default != null:
return $default(_that.gaplessEnabled,_that.crossfadeDurationSeconds,_that.defaultPlaybackSpeed,_that.hapticsEnabled,_that.locale,_that.themeMode,_that.userDisplayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupSettings implements BackupSettings {
  const _BackupSettings({required this.gaplessEnabled, required this.crossfadeDurationSeconds, required this.defaultPlaybackSpeed, required this.hapticsEnabled, this.locale, this.themeMode, this.userDisplayName});
  factory _BackupSettings.fromJson(Map<String, dynamic> json) => _$BackupSettingsFromJson(json);

@override final  bool gaplessEnabled;
@override final  int crossfadeDurationSeconds;
@override final  double defaultPlaybackSpeed;
@override final  bool hapticsEnabled;
@override final  String? locale;
@override final  String? themeMode;
@override final  String? userDisplayName;

/// Create a copy of BackupSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupSettingsCopyWith<_BackupSettings> get copyWith => __$BackupSettingsCopyWithImpl<_BackupSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupSettings&&(identical(other.gaplessEnabled, gaplessEnabled) || other.gaplessEnabled == gaplessEnabled)&&(identical(other.crossfadeDurationSeconds, crossfadeDurationSeconds) || other.crossfadeDurationSeconds == crossfadeDurationSeconds)&&(identical(other.defaultPlaybackSpeed, defaultPlaybackSpeed) || other.defaultPlaybackSpeed == defaultPlaybackSpeed)&&(identical(other.hapticsEnabled, hapticsEnabled) || other.hapticsEnabled == hapticsEnabled)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.userDisplayName, userDisplayName) || other.userDisplayName == userDisplayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gaplessEnabled,crossfadeDurationSeconds,defaultPlaybackSpeed,hapticsEnabled,locale,themeMode,userDisplayName);

@override
String toString() {
  return 'BackupSettings(gaplessEnabled: $gaplessEnabled, crossfadeDurationSeconds: $crossfadeDurationSeconds, defaultPlaybackSpeed: $defaultPlaybackSpeed, hapticsEnabled: $hapticsEnabled, locale: $locale, themeMode: $themeMode, userDisplayName: $userDisplayName)';
}


}

/// @nodoc
abstract mixin class _$BackupSettingsCopyWith<$Res> implements $BackupSettingsCopyWith<$Res> {
  factory _$BackupSettingsCopyWith(_BackupSettings value, $Res Function(_BackupSettings) _then) = __$BackupSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool gaplessEnabled, int crossfadeDurationSeconds, double defaultPlaybackSpeed, bool hapticsEnabled, String? locale, String? themeMode, String? userDisplayName
});




}
/// @nodoc
class __$BackupSettingsCopyWithImpl<$Res>
    implements _$BackupSettingsCopyWith<$Res> {
  __$BackupSettingsCopyWithImpl(this._self, this._then);

  final _BackupSettings _self;
  final $Res Function(_BackupSettings) _then;

/// Create a copy of BackupSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gaplessEnabled = null,Object? crossfadeDurationSeconds = null,Object? defaultPlaybackSpeed = null,Object? hapticsEnabled = null,Object? locale = freezed,Object? themeMode = freezed,Object? userDisplayName = freezed,}) {
  return _then(_BackupSettings(
gaplessEnabled: null == gaplessEnabled ? _self.gaplessEnabled : gaplessEnabled // ignore: cast_nullable_to_non_nullable
as bool,crossfadeDurationSeconds: null == crossfadeDurationSeconds ? _self.crossfadeDurationSeconds : crossfadeDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,defaultPlaybackSpeed: null == defaultPlaybackSpeed ? _self.defaultPlaybackSpeed : defaultPlaybackSpeed // ignore: cast_nullable_to_non_nullable
as double,hapticsEnabled: null == hapticsEnabled ? _self.hapticsEnabled : hapticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,themeMode: freezed == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String?,userDisplayName: freezed == userDisplayName ? _self.userDisplayName : userDisplayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
