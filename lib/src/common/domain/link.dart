import 'package:freezed_annotation/freezed_annotation.dart';

part 'link.freezed.dart';
part 'link.g.dart';

enum LinkPlatform {
  @JsonValue('ios')
  ios,
  @JsonValue('android')
  android,
  @JsonValue('web')
  web,
  @JsonValue('github')
  github,
  @JsonValue('pubdev')
  pubdev,
}

@freezed
abstract class Link with _$Link {
  const factory Link({
    String? url,
    String? label,
    LinkPlatform? platform,
  }) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}
