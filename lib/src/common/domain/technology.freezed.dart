// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technology.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Technology {

 String? get name; IconModel? get icon;
/// Create a copy of Technology
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnologyCopyWith<Technology> get copyWith => _$TechnologyCopyWithImpl<Technology>(this as Technology, _$identity);

  /// Serializes this Technology to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Technology&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,icon);

@override
String toString() {
  return 'Technology(name: $name, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $TechnologyCopyWith<$Res>  {
  factory $TechnologyCopyWith(Technology value, $Res Function(Technology) _then) = _$TechnologyCopyWithImpl;
@useResult
$Res call({
 String? name, IconModel? icon
});


$IconModelCopyWith<$Res>? get icon;

}
/// @nodoc
class _$TechnologyCopyWithImpl<$Res>
    implements $TechnologyCopyWith<$Res> {
  _$TechnologyCopyWithImpl(this._self, this._then);

  final Technology _self;
  final $Res Function(Technology) _then;

/// Create a copy of Technology
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? icon = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconModel?,
  ));
}
/// Create a copy of Technology
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IconModelCopyWith<$Res>? get icon {
    if (_self.icon == null) {
    return null;
  }

  return $IconModelCopyWith<$Res>(_self.icon!, (value) {
    return _then(_self.copyWith(icon: value));
  });
}
}


/// Adds pattern-matching-related methods to [Technology].
extension TechnologyPatterns on Technology {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Technology value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Technology() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Technology value)  $default,){
final _that = this;
switch (_that) {
case _Technology():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Technology value)?  $default,){
final _that = this;
switch (_that) {
case _Technology() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  IconModel? icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Technology() when $default != null:
return $default(_that.name,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  IconModel? icon)  $default,) {final _that = this;
switch (_that) {
case _Technology():
return $default(_that.name,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  IconModel? icon)?  $default,) {final _that = this;
switch (_that) {
case _Technology() when $default != null:
return $default(_that.name,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Technology implements Technology {
  const _Technology({this.name, this.icon});
  factory _Technology.fromJson(Map<String, dynamic> json) => _$TechnologyFromJson(json);

@override final  String? name;
@override final  IconModel? icon;

/// Create a copy of Technology
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnologyCopyWith<_Technology> get copyWith => __$TechnologyCopyWithImpl<_Technology>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnologyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Technology&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,icon);

@override
String toString() {
  return 'Technology(name: $name, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$TechnologyCopyWith<$Res> implements $TechnologyCopyWith<$Res> {
  factory _$TechnologyCopyWith(_Technology value, $Res Function(_Technology) _then) = __$TechnologyCopyWithImpl;
@override @useResult
$Res call({
 String? name, IconModel? icon
});


@override $IconModelCopyWith<$Res>? get icon;

}
/// @nodoc
class __$TechnologyCopyWithImpl<$Res>
    implements _$TechnologyCopyWith<$Res> {
  __$TechnologyCopyWithImpl(this._self, this._then);

  final _Technology _self;
  final $Res Function(_Technology) _then;

/// Create a copy of Technology
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? icon = freezed,}) {
  return _then(_Technology(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconModel?,
  ));
}

/// Create a copy of Technology
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IconModelCopyWith<$Res>? get icon {
    if (_self.icon == null) {
    return null;
  }

  return $IconModelCopyWith<$Res>(_self.icon!, (value) {
    return _then(_self.copyWith(icon: value));
  });
}
}

// dart format on
