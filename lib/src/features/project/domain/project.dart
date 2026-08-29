import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portfolio/src/common/domain/icon.dart';
import 'package:portfolio/src/common/domain/link.dart';
import 'package:portfolio/src/common/domain/technology.dart';
import 'package:portfolio/src/features/project/domain/project_status.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
abstract class Project with _$Project {
  const factory Project({
    String? name,
    String? description,
    String? url,
    IconModel? icon,
    String? screenshotPath,
    List<Technology>? technologies,
    List<Link>? links,
    bool? featured,
    ProjectStatus? status,
    String? role,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
