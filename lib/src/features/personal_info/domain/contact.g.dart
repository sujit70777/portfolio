// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  tooltip: json['tooltip'] as String?,
  url: json['url'] as String?,
  icon: json['icon'] == null
      ? null
      : IconModel.fromJson(json['icon'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'tooltip': instance.tooltip,
  'url': instance.url,
  'icon': instance.icon?.toJson(),
};
