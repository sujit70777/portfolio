import 'package:portfolio/src/features/about/domain/skill_category.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/localization/json_list_translation.dart';
import 'package:portfolio/src/localization/locale_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'about_repository.g.dart';

@riverpod
AboutRepository aboutRepository(Ref ref) {
  return AboutRepository(ref);
}

class AboutRepository {
  AboutRepository(this._ref);

  final Ref _ref;

  List<SkillCategory> getSkillCategories() {
    final locale = _ref.watch(localeControllerProvider).requireValue.locale;
    final jsonSkillCategories = trList(locale, LocaleKeys.skillCategories);
    return jsonSkillCategories.map((json) {
      return SkillCategory.fromJson(json);
    }).toList();
  }
}
