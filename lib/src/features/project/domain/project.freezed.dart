// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Project {
  String? get name;
  String? get description;
  String? get url;
  IconModel? get icon;
  String? get screenshotPath;
  List<Technology>? get technologies;
  List<Link>? get links;
  bool? get featured;
  ProjectStatus? get status;
  String? get role;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectCopyWith<Project> get copyWith =>
      _$ProjectCopyWithImpl<Project>(this as Project, _$identity);

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Project &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.screenshotPath, screenshotPath) ||
                other.screenshotPath == screenshotPath) &&
            const DeepCollectionEquality()
                .equals(other.technologies, technologies) &&
            const DeepCollectionEquality().equals(other.links, links) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      url,
      icon,
      screenshotPath,
      const DeepCollectionEquality().hash(technologies),
      const DeepCollectionEquality().hash(links),
      featured,
      status,
      role);

  @override
  String toString() {
    return 'Project(name: $name, description: $description, url: $url, icon: $icon, screenshotPath: $screenshotPath, technologies: $technologies, links: $links, featured: $featured, status: $status, role: $role)';
  }
}

/// @nodoc
abstract mixin class $ProjectCopyWith<$Res> {
  factory $ProjectCopyWith(Project value, $Res Function(Project) _then) =
      _$ProjectCopyWithImpl;
  @useResult
  $Res call(
      {String? name,
      String? description,
      String? url,
      IconModel? icon,
      String? screenshotPath,
      List<Technology>? technologies,
      List<Link>? links,
      bool? featured,
      ProjectStatus? status,
      String? role});

  $IconModelCopyWith<$Res>? get icon;
}

/// @nodoc
class _$ProjectCopyWithImpl<$Res> implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._self, this._then);

  final Project _self;
  final $Res Function(Project) _then;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? url = freezed,
    Object? icon = freezed,
    Object? screenshotPath = freezed,
    Object? technologies = freezed,
    Object? links = freezed,
    Object? featured = freezed,
    Object? status = freezed,
    Object? role = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconModel?,
      screenshotPath: freezed == screenshotPath
          ? _self.screenshotPath
          : screenshotPath // ignore: cast_nullable_to_non_nullable
              as String?,
      technologies: freezed == technologies
          ? _self.technologies
          : technologies // ignore: cast_nullable_to_non_nullable
              as List<Technology>?,
      links: freezed == links
          ? _self.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<Link>?,
      featured: freezed == featured
          ? _self.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProjectStatus?,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Project
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

/// Adds pattern-matching-related methods to [Project].
extension ProjectPatterns on Project {
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
    TResult Function(_Project value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Project() when $default != null:
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
    TResult Function(_Project value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Project():
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
    TResult? Function(_Project value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Project() when $default != null:
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
            String? name,
            String? description,
            String? url,
            IconModel? icon,
            String? screenshotPath,
            List<Technology>? technologies,
            List<Link>? links,
            bool? featured,
            ProjectStatus? status,
            String? role)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Project() when $default != null:
        return $default(
            _that.name,
            _that.description,
            _that.url,
            _that.icon,
            _that.screenshotPath,
            _that.technologies,
            _that.links,
            _that.featured,
            _that.status,
            _that.role);
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
            String? name,
            String? description,
            String? url,
            IconModel? icon,
            String? screenshotPath,
            List<Technology>? technologies,
            List<Link>? links,
            bool? featured,
            ProjectStatus? status,
            String? role)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Project():
        return $default(
            _that.name,
            _that.description,
            _that.url,
            _that.icon,
            _that.screenshotPath,
            _that.technologies,
            _that.links,
            _that.featured,
            _that.status,
            _that.role);
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
            String? name,
            String? description,
            String? url,
            IconModel? icon,
            String? screenshotPath,
            List<Technology>? technologies,
            List<Link>? links,
            bool? featured,
            ProjectStatus? status,
            String? role)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Project() when $default != null:
        return $default(
            _that.name,
            _that.description,
            _that.url,
            _that.icon,
            _that.screenshotPath,
            _that.technologies,
            _that.links,
            _that.featured,
            _that.status,
            _that.role);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Project implements Project {
  const _Project(
      {this.name,
      this.description,
      this.url,
      this.icon,
      this.screenshotPath,
      final List<Technology>? technologies,
      final List<Link>? links,
      this.featured,
      this.status,
      this.role})
      : _technologies = technologies,
        _links = links;
  factory _Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? url;
  @override
  final IconModel? icon;
  @override
  final String? screenshotPath;
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

  @override
  final bool? featured;
  @override
  final ProjectStatus? status;
  @override
  final String? role;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProjectCopyWith<_Project> get copyWith =>
      __$ProjectCopyWithImpl<_Project>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProjectToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Project &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.screenshotPath, screenshotPath) ||
                other.screenshotPath == screenshotPath) &&
            const DeepCollectionEquality()
                .equals(other._technologies, _technologies) &&
            const DeepCollectionEquality().equals(other._links, _links) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      url,
      icon,
      screenshotPath,
      const DeepCollectionEquality().hash(_technologies),
      const DeepCollectionEquality().hash(_links),
      featured,
      status,
      role);

  @override
  String toString() {
    return 'Project(name: $name, description: $description, url: $url, icon: $icon, screenshotPath: $screenshotPath, technologies: $technologies, links: $links, featured: $featured, status: $status, role: $role)';
  }
}

/// @nodoc
abstract mixin class _$ProjectCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$ProjectCopyWith(_Project value, $Res Function(_Project) _then) =
      __$ProjectCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? name,
      String? description,
      String? url,
      IconModel? icon,
      String? screenshotPath,
      List<Technology>? technologies,
      List<Link>? links,
      bool? featured,
      ProjectStatus? status,
      String? role});

  @override
  $IconModelCopyWith<$Res>? get icon;
}

/// @nodoc
class __$ProjectCopyWithImpl<$Res> implements _$ProjectCopyWith<$Res> {
  __$ProjectCopyWithImpl(this._self, this._then);

  final _Project _self;
  final $Res Function(_Project) _then;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? url = freezed,
    Object? icon = freezed,
    Object? screenshotPath = freezed,
    Object? technologies = freezed,
    Object? links = freezed,
    Object? featured = freezed,
    Object? status = freezed,
    Object? role = freezed,
  }) {
    return _then(_Project(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconModel?,
      screenshotPath: freezed == screenshotPath
          ? _self.screenshotPath
          : screenshotPath // ignore: cast_nullable_to_non_nullable
              as String?,
      technologies: freezed == technologies
          ? _self._technologies
          : technologies // ignore: cast_nullable_to_non_nullable
              as List<Technology>?,
      links: freezed == links
          ? _self._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<Link>?,
      featured: freezed == featured
          ? _self.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProjectStatus?,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Project
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
