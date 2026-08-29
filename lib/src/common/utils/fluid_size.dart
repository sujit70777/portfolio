import 'package:flutter/widgets.dart';

/// Flutter equivalent of CSS `clamp(min, preferredVw, max)` — scales
/// smoothly with viewport width instead of jumping at fixed breakpoints.
/// [preferredVwPercent] is the vw number as written in CSS (e.g. pass `5`
/// for `5vw`), not a 0–1 fraction.
double fluidSize(
  BuildContext context, {
  required double min,
  required double preferredVwPercent,
  required double max,
}) {
  final width = MediaQuery.sizeOf(context).width;
  final preferred = width * preferredVwPercent / 100;
  return preferred.clamp(min, max);
}
