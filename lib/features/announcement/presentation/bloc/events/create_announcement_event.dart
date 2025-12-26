import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/base/announcement_event.dart';

class CreateAnnouncementEvent extends AnnouncementEvent {
  final String title;
  final String content;
  final AnnouncementCategory category;
  final AnnouncementPriority priority;
  final AnnouncementTargetAudience targetAudience;

  const CreateAnnouncementEvent({
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.targetAudience,
  });

  @override
  List<Object?> get props => [
    title,
    content,
    category,
    priority,
    targetAudience,
  ];
}
