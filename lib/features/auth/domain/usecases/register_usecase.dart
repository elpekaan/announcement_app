import 'package:dartz/dartz.dart';
import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/core/usecases/base/base_usecase.dart';
import 'package:ciu_announcement/features/auth/domain/entities/user_entity.dart';
import 'package:ciu_announcement/features/auth/domain/repositories/auth_repository.dart';
import 'package:ciu_announcement/features/auth/domain/usecases/params/register_params.dart';

class RegisterUseCase implements BaseUseCase<UserEntity, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<BaseFailure, UserEntity>> call(RegisterParams params) {
    return _repository.register(
      params.name,
      params.email,
      params.password,
      params.role.apiValue,
    );
  }
}
