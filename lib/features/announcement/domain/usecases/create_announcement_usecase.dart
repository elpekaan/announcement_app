import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/core/usecases/base/base_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/params/create_announcement_params.dart';
import 'package:dartz/dartz.dart';

class CreateAnnouncementUseCase implements BaseUseCase<AnnouncementEntity, CreateAnnouncementParams> {
  final AnnouncementRepository _repository;

  CreateAnnouncementUseCase(this._repository);

  @override
  Future<Either<BaseFailure, AnnouncementEntity>> call(CreateAnnouncementParams params) {
    return _repository.create(
      title: params.title,
      content: params.content,
      category: params.category,
      priority: params.priority,
      targetAudience: params.targetAudience,
    );
  }
}