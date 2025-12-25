import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/core/usecases/base/base_usecase.dart';
import 'package:ciu_announcement/core/usecases/no_params.dart';
import 'package:ciu_announcement/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class IsLoggedInUseCase implements BaseUseCase<bool, NoParams> {
  final AuthRepository _repository;

  IsLoggedInUseCase(this._repository);

  @override
  Future<Either<BaseFailure, bool>> call(NoParams params) {
    return _repository.isLoggedIn();
  }
}
