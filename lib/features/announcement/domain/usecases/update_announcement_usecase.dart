import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/core/usecases/base/base_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/params/update_announcement_params.dart';
import 'package:dartz/dartz.dart';

class UpdateAnnouncementUseCase implements BaseUseCase<AnnouncementEntity, UpdateAnnouncementParams>{
  final AnnouncementRepository _repository;

  UpdateAnnouncementUseCase(this._repository);

  @override
  Future<Either<BaseFailure, AnnouncementEntity>> call(UpdateAnnouncementParams params) {
    return _repository.update(
        id: params.id,
        title: params.title,
        content: params.content,
        category: params.category,
        priority: params.priority,
        targetAudience: params.targetAudience,
    );
  }
}