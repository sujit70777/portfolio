import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/device_frame.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/personal_info/data/personal_info_repository.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/availability_badge.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/hero_stat_plaque.dart';
import 'package:portfolio/src/features/personal_info/presentation/widgets/resume_button.dart';
import 'package:portfolio/src/features/project/data/project_image_assets_provider.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

/// The hero — design brief 2's signature moment. Identity and the one
/// primary CTA read first (content problem #3: one obvious way to start a
/// conversation, resume demoted to a quiet link); the device frame + real
/// evidence numbers anchor the claim without three flat stat boxes
/// (content problem #1). Contacts beyond email/WhatsApp live in the
/// footer now, not here (content problem #2).
class PersonalInfoSection extends ConsumerWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumes =
        ref.watch(personalInfoRepositoryProvider).getResumes().toList();
    final contacts =
        ref.watch(personalInfoRepositoryProvider).getContacts().toList();
    final emailContact = contacts.firstWhereOrNull(
      (c) => c.url?.startsWith('mailto:') == true,
    );
    final whatsappContact = contacts.firstWhereOrNull(
      (c) => c.url?.contains('wa.me') == true,
    );
    final tantoImages = ref
        .watch(projectImagesProvider('Tanto'))
        .maybeWhen(data: (value) => value, orElse: () => const <String>[]);

    final stacked = Responsive.isMobile(context);
    final textTheme = Theme.of(context).textTheme;

    final textBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AvailabilityBadge(),
        gapH16,
        Text(
          tr(LocaleKeys.name),
          style: stacked ? textTheme.displayMedium : textTheme.displayLarge,
        ),
        gapH8,
        Text(tr(LocaleKeys.description), style: textTheme.titleLarge),
        gapH12,
        Text(
          tr(LocaleKeys.subDescription).toUpperCase(),
          style: monoLabelStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 18,
          runSpacing: 14,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (emailContact?.url != null)
              _HeroCta.primary(
                label: tr(LocaleKeys.heroPrimaryCta),
                url: emailContact!.url!,
              ),
            if (whatsappContact?.url != null)
              _HeroCta.secondary(
                label: tr(LocaleKeys.heroSecondaryCta),
                url: whatsappContact!.url!,
              ),
            if (resumes.isNotEmpty) ResumeButton(resumes: resumes),
          ],
        ),
      ],
    );

    final deviceBlock = _HeroDevice(
      imagePath: tantoImages.isNotEmpty ? tantoImages.first : null,
      width: stacked ? 220 : 230,
    );

    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBlock,
          gapH32,
          Center(child: deviceBlock),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: textBlock),
        gapW40,
        deviceBlock,
      ],
    );
  }
}

class _HeroDevice extends StatelessWidget {
  const _HeroDevice({required this.imagePath, required this.width});

  final String? imagePath;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final height = width / DeviceFrame.aspectRatio;

    final Widget screen = imagePath == null
        ? ColoredBox(
            color: theme.colorScheme.secondaryContainer,
            child: const Center(
              child: Icon(Icons.smartphone_outlined, color: Colors.white38),
            ),
          )
        : Image.asset(
            imagePath!,
            fit: BoxFit.cover,
            cacheWidth: (width * dpr).round(),
            cacheHeight: (height * dpr).round(),
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          DeviceFrame(width: width, screen: screen),
          const Positioned(bottom: -24, child: HeroStatPlaque()),
        ],
      ),
    );
  }
}

class _HeroCta extends StatelessWidget {
  const _HeroCta.primary({required this.label, required this.url})
      : _isPrimary = true;

  const _HeroCta.secondary({required this.label, required this.url})
      : _isPrimary = false;

  final String label;
  final String url;
  final bool _isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_isPrimary) {
      return FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(theme.colorScheme.tertiary),
          foregroundColor: WidgetStatePropertyAll(theme.colorScheme.secondary),
          shape: const WidgetStatePropertyAll(StadiumBorder()),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          ),
          textStyle: WidgetStatePropertyAll(
            theme.textTheme.labelLarge,
          ),
        ),
        onPressed: () => _onTap(context),
        child: Text(label),
      );
    }
    return OutlinedButton(
      style: ButtonStyle(
        side: WidgetStateProperty.resolveWith((states) {
          return BorderSide(
            width: states.contains(WidgetState.hovered) ? 2 : 1,
            color: states.contains(WidgetState.hovered)
                ? theme.colorScheme.tertiary
                : theme.colorScheme.onSurface.withAlpha(60),
          );
        }),
        foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onSurface),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        ),
        textStyle: WidgetStatePropertyAll(theme.textTheme.labelLarge),
      ),
      onPressed: () => _onTap(context),
      child: Text(label),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    try {
      await LaunchUrlHelper.launchURL(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessengerHelper.showLaunchUrlError(context, url: url);
      }
    }
  }
}
