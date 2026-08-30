// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Project _$ProjectFromJson(Map<String, dynamic> json) => _Project(
  name: json['name'] as String?,
  description: json['description'] as String?,
  url: json['url'] as String?,
  icon: json['icon'] == null
      ? null
      : IconModel.fromJson(json['icon'] as Map<String, dynamic>),
  screenshotPath: json['screenshotPath'] as String?,
  technologies: (json['technologies'] as List<dynamic>?)
      ?.map((e) => Technology.fromJson(e as Map<String, dynamic>))
      .toList(),
  links: (json['links'] as List<dynamic>?)
      ?.map((e) => Link.fromJson(e as Map<String, dynamic>))
      .toList(),
  featured: json['featured'] as bool?,
  status: $enumDecodeNullable(_$ProjectStatusEnumMap, json['status']),
  role: json['role'] as String?,
);

Map<String, dynamic> _$ProjectToJson(_Project instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'url': instance.url,
  'icon': instance.icon?.toJson(),
  'screenshotPath': instance.screenshotPath,
  'technologies': instance.technologies?.map((e) => e.toJson()).toList(),
  'links': instance.links?.map((e) => e.toJson()).toList(),
  'featured': instance.featured,
  'status': _$ProjectStatusEnumMap[instance.status],
  'role': instance.role,
};

const _$ProjectStatusEnumMap = {
  ProjectStatus.shipped: 'shipped',
  ProjectStatus.inDevelopment: 'inDevelopment',
};
