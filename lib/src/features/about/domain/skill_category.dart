import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_category.freezed.dart';
part 'skill_category.g.dart';

@freezed
abstract class SkillCategory with _$SkillCategory {
  const factory SkillCategory({
    String? category,
    List<String>? skills,
  }) = _SkillCategory;

  factory SkillCategory.fromJson(Map<String, dynamic> json) =>
      _$SkillCategoryFromJson(json);
}
