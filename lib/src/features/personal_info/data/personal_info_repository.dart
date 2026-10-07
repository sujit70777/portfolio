import 'package:easy_localization/easy_localization.dart';
import 'package:portfolio/src/features/personal_info/domain/contact.dart';
import 'package:portfolio/src/features/personal_info/domain/resume.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/localization/json_list_translation.dart';
import 'package:portfolio/src/localization/locale_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'personal_info_repository.g.dart';

@riverpod
PersonalInfoRepository personalInfoRepository(Ref ref) {
  return PersonalInfoRepository(ref);
}

class PersonalInfoRepository {
  PersonalInfoRepository(this._ref);

  final Ref _ref;

  List<Resume> getResumes() {
    final locale = _ref.watch(localeControllerProvider).requireValue.locale;
    final jsonResumes = trList(locale, LocaleKeys.resumes);
    final resumes = jsonResumes.map(Resume.fromJson).toList();
    // Deploy stamps ?v=<hash> onto resumeUrl in the built translations
    // asset. tr() reads that asset; trList/CodegenLoader does not.
    final runtimeUrl = tr(LocaleKeys.resumeUrl).trim();
    if (runtimeUrl.isEmpty || resumes.isEmpty) return resumes;

    final runtimeBase = runtimeUrl.split('?').first;
    return [
      for (final resume in resumes)
        (resume.url?.split('?').first == runtimeBase)
            ? resume.copyWith(url: runtimeUrl)
            : resume,
    ];
  }

  List<Contact> getContacts() {
    final locale = _ref.watch(localeControllerProvider).requireValue.locale;
    final jsonContacts = trList(locale, LocaleKeys.contacts);
    final contacts = jsonContacts.map((jsonContact) {
      return Contact.fromJson(jsonContact);
    }).toList();
    return contacts;
  }
}
