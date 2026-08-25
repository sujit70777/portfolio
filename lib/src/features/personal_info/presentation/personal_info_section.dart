import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/personal_info/presentation/personal_info_desktop.dart';
import 'package:portfolio/src/features/personal_info/presentation/personal_info_mobile.dart';
import 'package:portfolio/src/features/personal_info/presentation/personal_info_tablet.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';

class PersonalInfoSection extends ConsumerWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // PersonalInfoDesktop relies on a Spacer(), which needs the bounded
    // height that only GeneralDesktop's split-screen column provides.
    // GeneralTablet renders everything (including this) inside a scrollable
    // sliver, which is unbounded height — so this must key off the same
    // isSplitScreenDesktop cutoff GeneralSection uses to choose between
    // those two, not the generic isDesktop breakpoint.
    if (Responsive.isSplitScreenDesktop(context)) {
      return const PersonalInfoDesktop();
    }
    if (Responsive.isMobile(context)) {
      return const PersonalInfoMobile();
    }
    return const PersonalInfoTablet();
  }
}
