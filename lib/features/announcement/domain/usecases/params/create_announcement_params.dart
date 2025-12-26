import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';

class CreateAnnouncementParams {
  final String title;
  final String content;
  final AnnouncementCategory category;
  final AnnouncementPriority priority;
  final AnnouncementTargetAudience targetAudience;

  const CreateAnnouncementParams({
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.targetAudience
  });
}