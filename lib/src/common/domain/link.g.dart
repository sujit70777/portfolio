// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Link _$LinkFromJson(Map<String, dynamic> json) => _Link(
  url: json['url'] as String?,
  label: json['label'] as String?,
  platform: $enumDecodeNullable(_$LinkPlatformEnumMap, json['platform']),
);

Map<String, dynamic> _$LinkToJson(_Link instance) => <String, dynamic>{
  'url': instance.url,
  'label': instance.label,
  'platform': _$LinkPlatformEnumMap[instance.platform],
};

const _$LinkPlatformEnumMap = {
  LinkPlatform.ios: 'ios',
  LinkPlatform.android: 'android',
  LinkPlatform.web: 'web',
  LinkPlatform.github: 'github',
  LinkPlatform.pubdev: 'pubdev',
};
