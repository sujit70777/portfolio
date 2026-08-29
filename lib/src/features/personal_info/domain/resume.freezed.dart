// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resume.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Resume {
  String? get languageCode;
  String? get language;
  String? get url;

  /// Create a copy of Resume
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResumeCopyWith<Resume> get copyWith =>
      _$ResumeCopyWithImpl<Resume>(this as Resume, _$identity);

  /// Serializes this Resume to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Resume &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, languageCode, language, url);

  @override
  String toString() {
    return 'Resume(languageCode: $languageCode, language: $language, url: $url)';
  }
}

/// @nodoc
abstract mixin class $ResumeCopyWith<$Res> {
  factory $ResumeCopyWith(Resume value, $Res Function(Resume) _then) =
      _$ResumeCopyWithImpl;
  @useResult
  $Res call({String? languageCode, String? language, String? url});
}

/// @nodoc
class _$ResumeCopyWithImpl<$Res> implements $ResumeCopyWith<$Res> {
  _$ResumeCopyWithImpl(this._self, this._then);

  final Resume _self;
  final $Res Function(Resume) _then;

  /// Create a copy of Resume
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = freezed,
    Object? language = freezed,
    Object? url = freezed,
  }) {
    return _then(_self.copyWith(
      languageCode: freezed == languageCode
          ? _self.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Resume].
extension ResumePatterns on Resume {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Resume value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Resume() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Resume value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Resume():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Resume value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Resume() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String? languageCode, String? language, String? url)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Resume() when $default != null:
        return $default(_that.languageCode, _that.language, _that.url);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String? languageCode, String? language, String? url)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Resume():
        return $default(_that.languageCode, _that.language, _that.url);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String? languageCode, String? language, String? url)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Resume() when $default != null:
        return $default(_that.languageCode, _that.language, _that.url);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Resume implements Resume {
  const _Resume({this.languageCode, this.language, this.url});
  factory _Resume.fromJson(Map<String, dynamic> json) => _$ResumeFromJson(json);

  @override
  final String? languageCode;
  @override
  final String? language;
  @override
  final String? url;

  /// Create a copy of Resume
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResumeCopyWith<_Resume> get copyWith =>
      __$ResumeCopyWithImpl<_Resume>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ResumeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Resume &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, languageCode, language, url);

  @override
  String toString() {
    return 'Resume(languageCode: $languageCode, language: $language, url: $url)';
  }
}

/// @nodoc
abstract mixin class _$ResumeCopyWith<$Res> implements $ResumeCopyWith<$Res> {
  factory _$ResumeCopyWith(_Resume value, $Res Function(_Resume) _then) =
      __$ResumeCopyWithImpl;
  @override
  @useResult
  $Res call({String? languageCode, String? language, String? url});
}

/// @nodoc
class __$ResumeCopyWithImpl<$Res> implements _$ResumeCopyWith<$Res> {
  __$ResumeCopyWithImpl(this._self, this._then);

  final _Resume _self;
  final $Res Function(_Resume) _then;

  /// Create a copy of Resume
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? languageCode = freezed,
    Object? language = freezed,
    Object? url = freezed,
  }) {
    return _then(_Resume(
      languageCode: freezed == languageCode
          ? _self.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
