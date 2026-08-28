import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/contact_bar.dart';

/// All ten contact/store links, demoted out of the hero (design brief 2,
/// content problem #2 — ten equal-weight icons competing with the one
/// primary CTA) to the one place a hiring manager or client actually
/// wants an exhaustive list: the end of the page.
class SiteFooter extends ConsumerWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts =
        ref.watch(personalInfoRepositoryProvider).getContacts().toList();
    if (contacts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Theme.of(context).colorScheme.onSurface.withAlpha(24)),
        gapH24,
        ContactBar(contacts: contacts),
      ],
    );
  }
}
