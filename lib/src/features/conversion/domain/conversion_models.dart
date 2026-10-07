class OutcomeFact {
  const OutcomeFact({required this.value, required this.label});

  factory OutcomeFact.fromJson(Map<String, dynamic> json) => OutcomeFact(
        value: '${json['value'] ?? ''}',
        label: '${json['label'] ?? ''}',
      );

  final String value;
  final String label;
}

class TrustBadgeLink {
  const TrustBadgeLink({
    required this.label,
    required this.url,
    this.iconAsset,
  });

  factory TrustBadgeLink.fromJson(Map<String, dynamic> json) => TrustBadgeLink(
        label: '${json['label'] ?? ''}',
        url: '${json['url'] ?? ''}',
        iconAsset: json['iconAsset'] as String?,
      );

  final String label;
  final String url;
  final String? iconAsset;
}

class OpenSourcePackage {
  const OpenSourcePackage({
    required this.name,
    required this.blurb,
    required this.url,
  });

  factory OpenSourcePackage.fromJson(Map<String, dynamic> json) =>
      OpenSourcePackage(
        name: '${json['name'] ?? ''}',
        blurb: '${json['blurb'] ?? ''}',
        url: '${json['url'] ?? ''}',
      );

  final String name;
  final String blurb;
  final String url;
}

class NoteCard {
  const NoteCard({
    required this.title,
    required this.summary,
    required this.url,
  });

  factory NoteCard.fromJson(Map<String, dynamic> json) => NoteCard(
        title: '${json['title'] ?? ''}',
        summary: '${json['summary'] ?? ''}',
        url: '${json['url'] ?? ''}',
      );

  final String title;
  final String summary;
  final String url;
}

class HelpCard {
  const HelpCard({
    required this.title,
    required this.body,
    required this.tags,
  });

  factory HelpCard.fromJson(Map<String, dynamic> json) => HelpCard(
        title: '${json['title'] ?? ''}',
        body: '${json['body'] ?? ''}',
        tags: (json['tags'] as List?)?.map((e) => '$e').toList() ?? const [],
      );

  final String title;
  final String body;
  final List<String> tags;
}

class ProcessStep {
  const ProcessStep({required this.title, required this.body});

  factory ProcessStep.fromJson(Map<String, dynamic> json) => ProcessStep(
        title: '${json['title'] ?? ''}',
        body: '${json['body'] ?? ''}',
      );

  final String title;
  final String body;
}

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  factory FaqItem.fromJson(Map<String, dynamic> json) => FaqItem(
        question: '${json['question'] ?? ''}',
        answer: '${json['answer'] ?? ''}',
      );

  final String question;
  final String answer;
}

class EmailPreset {
  const EmailPreset({
    required this.label,
    required this.subject,
    required this.body,
  });

  factory EmailPreset.fromJson(Map<String, dynamic> json) => EmailPreset(
        label: '${json['label'] ?? ''}',
        subject: '${json['subject'] ?? ''}',
        body: '${json['body'] ?? ''}',
      );

  final String label;
  final String subject;
  final String body;
}

class Testimonial {
  const Testimonial({
    required this.quote,
    required this.name,
    this.role,
    this.company,
    this.linkedinUrl,
    this.relatedProject,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) => Testimonial(
        quote: '${json['quote'] ?? ''}',
        name: '${json['name'] ?? ''}',
        role: json['role'] as String?,
        company: json['company'] as String?,
        linkedinUrl: json['linkedinUrl'] as String?,
        relatedProject: json['relatedProject'] as String?,
      );

  final String quote;
  final String name;
  final String? role;
  final String? company;
  final String? linkedinUrl;
  final String? relatedProject;
}
