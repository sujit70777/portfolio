import 'package:portfolio/src/features/conversion/domain/conversion_models.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/localization/json_list_translation.dart';
import 'package:portfolio/src/localization/locale_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversion_repository.g.dart';

@riverpod
ConversionRepository conversionRepository(Ref ref) {
  return ConversionRepository(ref);
}

class ConversionRepository {
  ConversionRepository(this._ref);

  final Ref _ref;

  List<Map<String, dynamic>> _list(String key) {
    final locale = _ref.watch(localeControllerProvider).requireValue.locale;
    return trList(locale, key);
  }

  List<OutcomeFact> getOutcomes() => _list(LocaleKeys.outcomes)
      .map(OutcomeFact.fromJson)
      .where((o) => o.value.isNotEmpty && o.label.isNotEmpty)
      .toList();

  List<String> getTrustChips() => _list(LocaleKeys.trustChips)
      .map((m) => '${m['text'] ?? ''}'.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  List<TrustBadgeLink> getTrustBadgeLinks() => _list(LocaleKeys.trustBadgeLinks)
      .map(TrustBadgeLink.fromJson)
      .where((b) => b.label.isNotEmpty && b.url.isNotEmpty)
      .toList();

  List<OpenSourcePackage> getOpenSourcePackages() =>
      _list(LocaleKeys.openSourcePackages)
          .map(OpenSourcePackage.fromJson)
          .where((p) => p.name.isNotEmpty && p.url.isNotEmpty)
          .toList();

  List<NoteCard> getNotes() => _list(LocaleKeys.notes)
      .map(NoteCard.fromJson)
      .where((n) => n.title.isNotEmpty && n.url.isNotEmpty)
      .toList();

  List<HelpCard> getContractHelpCards() =>
      _list(LocaleKeys.contractHelpCards)
          .map(HelpCard.fromJson)
          .where((c) => c.title.isNotEmpty)
          .toList();

  List<ProcessStep> getEngagementSteps() =>
      _list(LocaleKeys.engagementSteps)
          .map(ProcessStep.fromJson)
          .where((s) => s.title.isNotEmpty)
          .toList();

  List<FaqItem> getFaqItems() => _list(LocaleKeys.faqItems)
      .map(FaqItem.fromJson)
      .where((f) => f.question.isNotEmpty && f.answer.isNotEmpty)
      .toList();

  List<EmailPreset> getEmailPresets() => _list(LocaleKeys.emailPresets)
      .map(EmailPreset.fromJson)
      .where((p) => p.label.isNotEmpty && p.subject.isNotEmpty)
      .toList();

  List<Testimonial> getTestimonials() => _list(LocaleKeys.testimonials)
      .map(Testimonial.fromJson)
      .where((t) => t.quote.isNotEmpty && t.name.isNotEmpty)
      .toList();
}
