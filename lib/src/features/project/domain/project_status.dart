import 'package:freezed_annotation/freezed_annotation.dart';

enum ProjectStatus {
  @JsonValue('shipped')
  shipped,
  @JsonValue('inDevelopment')
  inDevelopment,
}
