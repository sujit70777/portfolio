import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

/// Copies a share link (a project, a note) for someone to forward: the
/// link reopens the same modal on arrival (see DeepLinkHandler). Confirms
/// in place — a SnackBar would land on the page behind the modal's
/// barrier.
class CopyLinkButton extends StatefulWidget {
  const CopyLinkButton({super.key, required this.url});

  final String url;

  @override
  State<CopyLinkButton> createState() => _CopyLinkButtonState();
}

class _CopyLinkButtonState extends State<CopyLinkButton> {
  static const _confirmationDuration = Duration(seconds: 2);

  bool _copied = false;
  Timer? _reset;

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.url));
    if (!mounted) return;
    setState(() => _copied = true);
    _reset?.cancel();
    _reset = Timer(_confirmationDuration, () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: TextButton.icon(
        style: ButtonStyle(
          foregroundColor:
              WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary),
        ),
        onPressed: _copy,
        icon: Icon(_copied ? Icons.check : Icons.link, size: 18),
        label: Text(
          _copied
              ? tr(LocaleKeys.projectLinkCopied)
              : tr(LocaleKeys.copyProjectLink),
        ),
      ),
    );
  }
}
