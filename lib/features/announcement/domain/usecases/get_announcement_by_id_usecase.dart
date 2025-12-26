import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/core/usecases/base/base_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/params/get_announcement_params.dart';
import 'package:dartz/dartz.dart';

class GetAnnouncementByIdUseCase implements BaseUseCase<AnnouncementEntity, GetAnnouncementParams>{
  final AnnouncementRepository _repository;

  GetAnnouncementByIdUseCase(this._repository);

  @override
  Future<Either<BaseFailure, AnnouncementEntity>> call(GetAnnouncementParams params) {
    return _repository.getById(params.id);
  }
}