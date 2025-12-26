import 'package:ciu_announcement/features/announcement/data/models/announcement_model.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';

abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> getAll();

  Future<AnnouncementModel> getById(int id);

  Future<AnnouncementModel> create({
    required String title,
    required String content,
    required AnnouncementCategory category,
    required AnnouncementPriority priority,
    required AnnouncementTargetAudience targetAudience,
  });

  Future<AnnouncementModel> update({
    required int id,
    required String title,
    required String content,
    required AnnouncementCategory category,
    required AnnouncementPriority priority,
    required AnnouncementTargetAudience targetAudience,
  });

  Future<void> delete(int id);
}