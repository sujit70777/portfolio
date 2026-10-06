import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_portfolio.dart';

void main() {
  // The tablet and desktop layouts share one ScrollController, and for the
  // frame in which the window crosses the desktop breakpoint both of their
  // scroll views are attached to it. Anything reading `controller.position`
  // then asserted ("attached to multiple scroll views").
  testWidgets('crossing the desktop breakpoint does not throw', (tester) async {
    await pumpPortfolio(tester, size: const Size(1100, 1200));
    await tester.pumpAndSettle();

    tester.view.physicalSize = const Size(2033, 1200);
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();

    tester.view.physicalSize = const Size(1100, 1200);
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
  });
}
