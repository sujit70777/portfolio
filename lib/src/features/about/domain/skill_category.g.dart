// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SkillCategoryImpl _$$SkillCategoryImplFromJson(Map<String, dynamic> json) =>
    _$SkillCategoryImpl(
      category: json['category'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$SkillCategoryImplToJson(_$SkillCategoryImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'skills': instance.skills,
    };
