import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/core/usecases/base/base_usecase.dart';
import 'package:ciu_announcement/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:ciu_announcement/features/announcement/domain/usecases/params/delete_announcement_params.dart';
import 'package:dartz/dartz.dart';

class DeleteAnnouncementUseCase implements BaseUseCase<void, DeleteAnnouncementParams>{
  final AnnouncementRepository _repository;

  DeleteAnnouncementUseCase(this._repository);

  @override
  Future<Either<BaseFailure, void>> call(DeleteAnnouncementParams params) {
    return _repository.delete(params.id);
  }
}