// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'experience.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Experience {
  String? get role;
  String? get company;
  String? get description;
  String? get url;
  bool? get isPresent;
  int? get startYear;
  int? get startMonth;
  int? get endYear;
  int? get endMonth;
  List<Technology>? get technologies;
  List<Link>? get links;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExperienceCopyWith<Experience> get copyWith =>
      _$ExperienceCopyWithImpl<Experience>(this as Experience, _$identity);

  /// Serializes this Experience to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Experience &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.isPresent, isPresent) ||
                other.isPresent == isPresent) &&
            (identical(other.startYear, startYear) ||
                other.startYear == startYear) &&
            (identical(other.startMonth, startMonth) ||
                other.startMonth == startMonth) &&
            (identical(other.endYear, endYear) || other.endYear == endYear) &&
            (identical(other.endMonth, endMonth) ||
                other.endMonth == endMonth) &&
            const DeepCollectionEquality()
                .equals(other.technologies, technologies) &&
            const DeepCollectionEquality().equals(other.links, links));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      role,
      company,
      description,
      url,
      isPresent,
      startYear,
      startMonth,
      endYear,
      endMonth,
      const DeepCollectionEquality().hash(technologies),
      const DeepCollectionEquality().hash(links));

  @override
  String toString() {
    return 'Experience(role: $role, company: $company, description: $description, url: $url, isPresent: $isPresent, startYear: $startYear, startMonth: $startMonth, endYear: $endYear, endMonth: $endMonth, technologies: $technologies, links: $links)';
  }
}

/// @nodoc
abstract mixin class $ExperienceCopyWith<$Res> {
  factory $ExperienceCopyWith(
          Experience value, $Res Function(Experience) _then) =
      _$ExperienceCopyWithImpl;
  @useResult
  $Res call(
      {String? role,
      String? company,
      String? description,
      String? url,
      bool? isPresent,
      int? startYear,
      int? startMonth,
      int? endYear,
      int? endMonth,
      List<Technology>? technologies,
      List<Link>? links});
}

/// @nodoc
class _$ExperienceCopyWithImpl<$Res> implements $ExperienceCopyWith<$Res> {
  _$ExperienceCopyWithImpl(this._self, this._then);

  final Experience _self;
  final $Res Function(Experience) _then;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = freezed,
    Object? company = freezed,
    Object? description = freezed,
    Object? url = freezed,
    Object? isPresent = freezed,
    Object? startYear = freezed,
    Object? startMonth = freezed,
    Object? endYear = freezed,
    Object? endMonth = freezed,
    Object? technologies = freezed,
    Object? links = freezed,
  }) {
    return _then(_self.copyWith(
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _self.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      isPresent: freezed == isPresent
          ? _self.isPresent
          : isPresent // ignore: cast_nullable_to_non_nullable
              as bool?,
      startYear: freezed == startYear
          ? _self.startYear
          : startYear // ignore: cast_nullable_to_non_nullable
              as int?,
      startMonth: freezed == startMonth
          ? _self.startMonth
          : startMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      endYear: freezed == endYear
          ? _self.endYear
          : endYear // ignore: cast_nullable_to_non_nullable
              as int?,
      endMonth: freezed == endMonth
          ? _self.endMonth
          : endMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      technologies: freezed == technologies
          ? _self.technologies
          : technologies // ignore: cast_nullable_to_non_nullable
              as List<Technology>?,
      links: freezed == links
          ? _self.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<Link>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Experience].
extension ExperiencePatterns on Experience {
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
    TResult Function(_Experience value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Experience() when $default != null:
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
    TResult Function(_Experience value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Experience():
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
    TResult? Function(_Experience value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Experience() when $default != null:
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
    TResult Function(
            String? role,
            String? company,
            String? description,
            String? url,
            bool? isPresent,
            int? startYear,
            int? startMonth,
            int? endYear,
            int? endMonth,
            List<Technology>? technologies,
            List<Link>? links)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Experience() when $default != null:
        return $default(
            _that.role,
            _that.company,
            _that.description,
            _that.url,
            _that.isPresent,
            _that.startYear,
            _that.startMonth,
            _that.endYear,
            _that.endMonth,
            _that.technologies,
            _that.links);
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
    TResult Function(
            String? role,
            String? company,
            String? description,
            String? url,
            bool? isPresent,
            int? startYear,
            int? startMonth,
            int? endYear,
            int? endMonth,
            List<Technology>? technologies,
            List<Link>? links)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Experience():
        return $default(
            _that.role,
            _that.company,
            _that.description,
            _that.url,
            _that.isPresent,
            _that.startYear,
            _that.startMonth,
            _that.endYear,
            _that.endMonth,
            _that.technologies,
            _that.links);
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
    TResult? Function(
            String? role,
            String? company,
            String? description,
            String? url,
            bool? isPresent,
            int? startYear,
            int? startMonth,
            int? endYear,
            int? endMonth,
            List<Technology>? technologies,
            List<Link>? links)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Experience() when $default != null:
        return $default(
            _that.role,
            _that.company,
            _that.description,
            _that.url,
            _that.isPresent,
            _that.startYear,
            _that.startMonth,
            _that.endYear,
            _that.endMonth,
            _that.technologies,
            _that.links);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Experience implements Experience {
  const _Experience(
      {this.role,
      this.company,
      this.description,
      this.url,
      this.isPresent,
      this.startYear,
      this.startMonth,
      this.endYear,
      this.endMonth,
      final List<Technology>? technologies,
      final List<Link>? links})
      : _technologies = technologies,
        _links = links;
  factory _Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @override
  final String? role;
  @override
  final String? company;
  @override
  final String? description;
  @override
  final String? url;
  @override
  final bool? isPresent;
  @override
  final int? startYear;
  @override
  final int? startMonth;
  @override
  final int? endYear;
  @override
  final int? endMonth;
  final List<Technology>? _technologies;
  @override
  List<Technology>? get technologies {
    final value = _technologies;
    if (value == null) return null;
    if (_technologies is EqualUnmodifiableListView) return _technologies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Link>? _links;
  @override
  List<Link>? get links {
    final value = _links;
    if (value == null) return null;
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExperienceCopyWith<_Experience> get copyWith =>
      __$ExperienceCopyWithImpl<_Experience>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExperienceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Experience &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.isPresent, isPresent) ||
                other.isPresent == isPresent) &&
            (identical(other.startYear, startYear) ||
                other.startYear == startYear) &&
            (identical(other.startMonth, startMonth) ||
                other.startMonth == startMonth) &&
            (identical(other.endYear, endYear) || other.endYear == endYear) &&
            (identical(other.endMonth, endMonth) ||
                other.endMonth == endMonth) &&
            const DeepCollectionEquality()
                .equals(other._technologies, _technologies) &&
            const DeepCollectionEquality().equals(other._links, _links));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      role,
      company,
      description,
      url,
      isPresent,
      startYear,
      startMonth,
      endYear,
      endMonth,
      const DeepCollectionEquality().hash(_technologies),
      const DeepCollectionEquality().hash(_links));

  @override
  String toString() {
    return 'Experience(role: $role, company: $company, description: $description, url: $url, isPresent: $isPresent, startYear: $startYear, startMonth: $startMonth, endYear: $endYear, endMonth: $endMonth, technologies: $technologies, links: $links)';
  }
}

/// @nodoc
abstract mixin class _$ExperienceCopyWith<$Res>
    implements $ExperienceCopyWith<$Res> {
  factory _$ExperienceCopyWith(
          _Experience value, $Res Function(_Experience) _then) =
      __$ExperienceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? role,
      String? company,
      String? description,
      String? url,
      bool? isPresent,
      int? startYear,
      int? startMonth,
      int? endYear,
      int? endMonth,
      List<Technology>? technologies,
      List<Link>? links});
}

/// @nodoc
class __$ExperienceCopyWithImpl<$Res> implements _$ExperienceCopyWith<$Res> {
  __$ExperienceCopyWithImpl(this._self, this._then);

  final _Experience _self;
  final $Res Function(_Experience) _then;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? role = freezed,
    Object? company = freezed,
    Object? description = freezed,
    Object? url = freezed,
    Object? isPresent = freezed,
    Object? startYear = freezed,
    Object? startMonth = freezed,
    Object? endYear = freezed,
    Object? endMonth = freezed,
    Object? technologies = freezed,
    Object? links = freezed,
  }) {
    return _then(_Experience(
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _self.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      isPresent: freezed == isPresent
          ? _self.isPresent
          : isPresent // ignore: cast_nullable_to_non_nullable
              as bool?,
      startYear: freezed == startYear
          ? _self.startYear
          : startYear // ignore: cast_nullable_to_non_nullable
              as int?,
      startMonth: freezed == startMonth
          ? _self.startMonth
          : startMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      endYear: freezed == endYear
          ? _self.endYear
          : endYear // ignore: cast_nullable_to_non_nullable
              as int?,
      endMonth: freezed == endMonth
          ? _self.endMonth
          : endMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      technologies: freezed == technologies
          ? _self._technologies
          : technologies // ignore: cast_nullable_to_non_nullable
              as List<Technology>?,
      links: freezed == links
          ? _self._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<Link>?,
    ));
  }
}

// dart format on
