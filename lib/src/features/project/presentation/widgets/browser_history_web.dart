// ignore: avoid_web_libraries_in_flutter, conditional import for web only
import 'dart:html' as html;

void replaceBrowserUrl(String url) {
  html.window.history.replaceState(null, '', url);
}
