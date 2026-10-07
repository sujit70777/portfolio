// dart:html is absent under dart2wasm, so keying on it would silently pick
// the stub for the --wasm build. js_interop exists in both web compilers.
export 'browser_history_stub.dart'
    if (dart.library.js_interop) 'browser_history_web.dart';
