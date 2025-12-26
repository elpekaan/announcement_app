import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/core/usecases/base/base_usecase.dart';
import 'package:ciu_announcement/core/usecases/no_params.dart';
import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllAnnouncementsUseCase implements BaseUseCase<List<AnnouncementEntity>, NoParams>{
  final AnnouncementRepository _repository;

  GetAllAnnouncementsUseCase(this._repository);

  @override
  Future<Either<BaseFailure, List<AnnouncementEntity>>> call(NoParams params) {
    return _repository.getAll();
  }
}