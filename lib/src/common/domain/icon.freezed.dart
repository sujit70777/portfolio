// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IconModel {

 String? get assetName; String? get codePoint; String? get fontFamily; String? get color;
/// Create a copy of IconModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IconModelCopyWith<IconModel> get copyWith => _$IconModelCopyWithImpl<IconModel>(this as IconModel, _$identity);

  /// Serializes this IconModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IconModel&&(identical(other.assetName, assetName) || other.assetName == assetName)&&(identical(other.codePoint, codePoint) || other.codePoint == codePoint)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetName,codePoint,fontFamily,color);

@override
String toString() {
  return 'IconModel(assetName: $assetName, codePoint: $codePoint, fontFamily: $fontFamily, color: $color)';
}


}

/// @nodoc
abstract mixin class $IconModelCopyWith<$Res>  {
  factory $IconModelCopyWith(IconModel value, $Res Function(IconModel) _then) = _$IconModelCopyWithImpl;
@useResult
$Res call({
 String? assetName, String? codePoint, String? fontFamily, String? color
});




}
/// @nodoc
class _$IconModelCopyWithImpl<$Res>
    implements $IconModelCopyWith<$Res> {
  _$IconModelCopyWithImpl(this._self, this._then);

  final IconModel _self;
  final $Res Function(IconModel) _then;

/// Create a copy of IconModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetName = freezed,Object? codePoint = freezed,Object? fontFamily = freezed,Object? color = freezed,}) {
  return _then(_self.copyWith(
assetName: freezed == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String?,codePoint: freezed == codePoint ? _self.codePoint : codePoint // ignore: cast_nullable_to_non_nullable
as String?,fontFamily: freezed == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [IconModel].
extension IconModelPatterns on IconModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IconModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IconModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IconModel value)  $default,){
final _that = this;
switch (_that) {
case _IconModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IconModel value)?  $default,){
final _that = this;
switch (_that) {
case _IconModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? assetName,  String? codePoint,  String? fontFamily,  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IconModel() when $default != null:
return $default(_that.assetName,_that.codePoint,_that.fontFamily,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? assetName,  String? codePoint,  String? fontFamily,  String? color)  $default,) {final _that = this;
switch (_that) {
case _IconModel():
return $default(_that.assetName,_that.codePoint,_that.fontFamily,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? assetName,  String? codePoint,  String? fontFamily,  String? color)?  $default,) {final _that = this;
switch (_that) {
case _IconModel() when $default != null:
return $default(_that.assetName,_that.codePoint,_that.fontFamily,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IconModel implements IconModel {
  const _IconModel({this.assetName, this.codePoint, this.fontFamily, this.color});
  factory _IconModel.fromJson(Map<String, dynamic> json) => _$IconModelFromJson(json);

@override final  String? assetName;
@override final  String? codePoint;
@override final  String? fontFamily;
@override final  String? color;

/// Create a copy of IconModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IconModelCopyWith<_IconModel> get copyWith => __$IconModelCopyWithImpl<_IconModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IconModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IconModel&&(identical(other.assetName, assetName) || other.assetName == assetName)&&(identical(other.codePoint, codePoint) || other.codePoint == codePoint)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetName,codePoint,fontFamily,color);

@override
String toString() {
  return 'IconModel(assetName: $assetName, codePoint: $codePoint, fontFamily: $fontFamily, color: $color)';
}


}

/// @nodoc
abstract mixin class _$IconModelCopyWith<$Res> implements $IconModelCopyWith<$Res> {
  factory _$IconModelCopyWith(_IconModel value, $Res Function(_IconModel) _then) = __$IconModelCopyWithImpl;
@override @useResult
$Res call({
 String? assetName, String? codePoint, String? fontFamily, String? color
});




}
/// @nodoc
class __$IconModelCopyWithImpl<$Res>
    implements _$IconModelCopyWith<$Res> {
  __$IconModelCopyWithImpl(this._self, this._then);

  final _IconModel _self;
  final $Res Function(_IconModel) _then;

/// Create a copy of IconModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetName = freezed,Object? codePoint = freezed,Object? fontFamily = freezed,Object? color = freezed,}) {
  return _then(_IconModel(
assetName: freezed == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String?,codePoint: freezed == codePoint ? _self.codePoint : codePoint // ignore: cast_nullable_to_non_nullable
as String?,fontFamily: freezed == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
