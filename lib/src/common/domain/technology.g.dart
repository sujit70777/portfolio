// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technology.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Technology _$TechnologyFromJson(Map<String, dynamic> json) => _Technology(
  name: json['name'] as String?,
  icon: json['icon'] == null
      ? null
      : IconModel.fromJson(json['icon'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TechnologyToJson(_Technology instance) =>
    <String, dynamic>{'name': instance.name, 'icon': instance.icon?.toJson()};
