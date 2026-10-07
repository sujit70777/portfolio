import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/src/features/conversion/presentation/contract_work_section.dart';
import 'package:portfolio/src/features/conversion/presentation/notes_section.dart';
import 'package:portfolio/src/features/conversion/presentation/open_source_section.dart';
import 'package:portfolio/src/features/conversion/presentation/testimonials_section.dart';
import 'package:portfolio/src/features/conversion/presentation/video_intro_section.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/outcome_cards.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/recruiter_fit_strip.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/trust_strip.dart';
import 'package:portfolio/src/features/general/presentation/general_section.dart';

import 'helpers/pump_portfolio.dart';

void main() {
  testWidgets('Wave 1 conversion blocks are visible with real content', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expect(find.byType(GeneralSection), findsOneWidget);
    expect(find.byType(TrustStrip), findsOneWidget);
    expect(find.byType(RecruiterFitStrip), findsOneWidget);
    expect(find.byType(OutcomeCards), findsOneWidget);

    expect(find.textContaining('FinTech'), findsWidgets);
    expect(find.textContaining('For recruiters'), findsOneWidget);
    expect(find.textContaining('0.5'), findsWidgets);
    expect(find.textContaining('11 years shipping'), findsWidgets);
  });

  testWidgets('empty optional sections stay hidden; filled ones show', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expect(find.textContaining('Play intro'), findsNothing);
    expect(find.byType(VideoIntroSection), findsOneWidget);

    expect(
      find.descendant(
        of: find.byType(TestimonialsSection),
        matching: find.textContaining('Recommendations'),
      ),
      findsNothing,
    );

    expect(find.byType(OpenSourceSection), findsOneWidget);
    expect(find.text('flutter_crdt_sync_kit'), findsWidgets);
    expect(find.byType(NotesSection), findsOneWidget);
    expect(find.textContaining('Native scanner behind'), findsOneWidget);
    expect(find.byType(ContractWorkSection), findsOneWidget);
    expect(find.textContaining('Who I help'), findsOneWidget);
    expect(find.textContaining('15-min intro call'), findsNothing);
  });
}
