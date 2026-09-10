# Every target here is a command, not a file. Without this, `make web` finds
# the web/ directory sitting there, decides the target is already built, and
# silently does nothing.
.PHONY: build-web localization launcher_icons native_splash

# The web build must pass --wasm: web/index.html preloads the engine during
# HTML parse and states which compile target it expects in HAS_WASM_BUILD,
# and the deploy workflow fails if the two disagree. Use this rather than a
# bare `flutter build web` so a local build matches what CI ships.
build-web:
	flutter build web --wasm --release

localization:
	dart run easy_localization:generate -S assets/translations -f json -O lib/src/localization/generated -o locale_json.g.dart
	dart run easy_localization:generate -S assets/translations -f keys -O lib/src/localization/generated -o locale_keys.g.dart

launcher_icons:
	dart run flutter_launcher_icons

native_splash:
	dart run flutter_native_splash:create
