/// Converts a display name into the same folder-name form used under
/// assets/projectimage/ (lowercase, non-alphanumeric runs collapsed to a
/// single hyphen, no leading/trailing hyphens).
String slugify(String input) {
  final collapsed = input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  return collapsed.replaceAll(RegExp(r'^-+|-+$'), '');
}
