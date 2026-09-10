import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

// keepAlive, because this is a handle to a single underlying store rather
// than a piece of derived state. Left auto-disposing, it is torn down the
// moment nothing is listening and rebuilt on the next read — and anything
// that watches it rebuilds too, re-reading whatever happens to be on disk at
// that instant. That is how the theme toggle came undone: writing a
// preference and re-reading it are not instantaneous on the web, so a
// re-created store handed BrightnessController the old value back and
// reverted the theme the visitor had just chosen.
@Riverpod(keepAlive: true)
FutureOr<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}
