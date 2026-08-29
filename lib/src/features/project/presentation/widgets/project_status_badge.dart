import 'package:flutter/material.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/project/domain/project_status.dart';

/// A muted amber, deliberately distinct from the app's one accent
/// (`colorScheme.tertiary`, used for "shipped") — "in development" should
/// never read as the same kind of signal as a finished, shipped project.
Color _inDevelopmentColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xffe0b04a)
      : const Color(0xff8a5a00);
}

String statusLabel(ProjectStatus? status) {
  return status == ProjectStatus.inDevelopment ? 'IN DEVELOPMENT' : 'SHIPPED';
}

Color statusColor(BuildContext context, ProjectStatus? status) {
  return status == ProjectStatus.inDevelopment
      ? _inDevelopmentColor(context)
      : Theme.of(context).colorScheme.tertiary;
}

/// Small mono status tag — "SHIPPED" in the app's accent, "IN DEVELOPMENT"
/// in a muted amber so the two are never confused at a glance.
class ProjectStatusBadge extends StatelessWidget {
  const ProjectStatusBadge({super.key, required this.status, this.fontSize = 11});

  final ProjectStatus? status;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      statusLabel(status),
      style: monoLabelStyle(fontSize: fontSize, color: statusColor(context, status)),
    );
  }
}
