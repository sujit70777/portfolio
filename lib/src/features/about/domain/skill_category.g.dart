// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SkillCategory _$SkillCategoryFromJson(Map<String, dynamic> json) =>
    _SkillCategory(
      category: json['category'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SkillCategoryToJson(_SkillCategory instance) =>
    <String, dynamic>{
      'category': instance.category,
      'skills': instance.skills,
    };
