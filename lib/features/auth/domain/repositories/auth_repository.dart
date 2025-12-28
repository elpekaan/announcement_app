import 'package:dartz/dartz.dart';
import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<BaseFailure, UserEntity>> login(String email, String password);
  Future<Either<BaseFailure, UserEntity>> register(String name, String email, String password, String role);
  Future<Either<BaseFailure, void>> logout();
  Future<Either<BaseFailure, UserEntity>> getCurrentUser();
  Future<Either<BaseFailure, bool>> isLoggedIn();
}