import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<BaseFailure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<BaseFailure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<BaseFailure, void>> logout();

  Future<Either<BaseFailure, UserEntity>> getCurrentUser();

  Future<Either<BaseFailure, bool>> isLoggedIn();
}
