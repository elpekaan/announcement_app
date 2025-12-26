import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';
import 'package:dartz/dartz.dart';

abstract class AnnouncementRepository {
  Future<Either<BaseFailure, List<AnnouncementEntity>>> getAll();

  Future<Either<BaseFailure, AnnouncementEntity>> getById(int id);

  Future<Either<BaseFailure, AnnouncementEntity>> create({
    required String title,
    required String content,
    required AnnouncementCategory category,
    required AnnouncementPriority priority,
    required AnnouncementTargetAudience targetAudience,
  });

  Future<Either<BaseFailure, AnnouncementEntity>> update({
    required int id,
    required String title,
    required String content,
    required AnnouncementCategory category,
    required AnnouncementPriority priority,
    required AnnouncementTargetAudience targetAudience,
  });

  Future<Either<BaseFailure, void>> delete(int id);
}
