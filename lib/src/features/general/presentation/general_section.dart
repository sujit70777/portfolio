import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/general/presentation/general_section_desktop.dart';
import 'package:portfolio/src/features/general/presentation/general_section_tablet.dart';
import 'package:portfolio/src/features/general/presentation/widgets/bottom_banner.dart';
import 'package:portfolio/src/features/general/presentation/widgets/deep_link_handler.dart';
import 'package:portfolio/src/features/general/presentation/widgets/end_drawer.dart';
import 'package:portfolio/src/features/general/presentation/widgets/safe_area.dart';
import 'package:portfolio/src/features/general/presentation/widgets/scroll_progress_bar.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/features/page_search/presentation/page_search_scope.dart';

class GeneralSection extends ConsumerWidget {
  const GeneralSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSplitScreen = Responsive.isSplitScreenDesktop(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      endDrawer: const MySafeArea(
        child: EndDrawer(),
      ),
      body: MySafeArea(
        child: PageSearchScope(
          child: Stack(
            children: [
              isSplitScreen ? const GeneralDesktop() : const GeneralTablet(),
              const Align(
                alignment: Alignment.topCenter,
                child: ScrollProgressBar(),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: BottomBanner(),
              ),
              const DeepLinkHandler(),
            ],
          ),
        ),
      ),
    );
  }
}
