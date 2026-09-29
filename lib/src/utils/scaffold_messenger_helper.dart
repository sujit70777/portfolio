import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class ScaffoldMessengerHelper {
  ScaffoldMessengerHelper._();

  static void showLaunchUrlError(BuildContext context, {String? url}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${tr(LocaleKeys.openUrlError)} $url"),
        ),
      );
    }
  }

  static void showMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// A `mailto:` link fails silently for anyone on web mail with no mail
  /// app registered — common among recruiters on work laptops. There's no
  /// way to detect that from the page, so every mailto tap also offers the
  /// address to copy.
  static void showEmailFallback(BuildContext context, {required String email}) {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          content: Text('${tr(LocaleKeys.emailOpening)} $email'),
          action: SnackBarAction(
            label: tr(LocaleKeys.copyEmail),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: email));
              messenger.showSnackBar(
                SnackBar(content: Text(tr(LocaleKeys.emailCopied))),
              );
            },
          ),
        ),
      );
  }
}
