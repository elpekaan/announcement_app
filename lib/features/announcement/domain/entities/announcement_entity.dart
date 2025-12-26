import 'package:ciu_announcement/core/entities/base/base_entity.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';

class AnnouncementEntity extends BaseEntity {
  final String title;
  final String content;
  final AnnouncementCategory category;
  final AnnouncementPriority priority;
  final AnnouncementTargetAudience targetAudience;
  final int authorId;
  final String authorName;

  const AnnouncementEntity({
    required super.id,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.targetAudience,
    required this.authorId,
    required this.authorName,
    required super.createdAt,
    super.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    category,
    priority,
    targetAudience,
    authorId,
    authorName,
    createdAt,
    updatedAt,
  ];
}
