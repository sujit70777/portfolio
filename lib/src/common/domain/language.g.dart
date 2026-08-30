// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Language _$LanguageFromJson(Map<String, dynamic> json) => _Language(
  code: json['code'] as String?,
  name: json['name'] as String?,
  nativeName: json['nativeName'] as String?,
  icon: json['icon'] == null
      ? null
      : IconModel.fromJson(json['icon'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LanguageToJson(_Language instance) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
  'nativeName': instance.nativeName,
  'icon': instance.icon?.toJson(),
};
