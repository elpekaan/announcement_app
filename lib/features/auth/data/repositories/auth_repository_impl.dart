import 'package:ciu_announcement/core/errors/exceptions/server_exception.dart';
import 'package:ciu_announcement/core/errors/exceptions/unauthorized_exception.dart';
import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/core/errors/failures/server_failure.dart';
import 'package:ciu_announcement/core/errors/failures/unauthorized_failure.dart';
import 'package:ciu_announcement/core/network/network_info/base/base_network_info.dart';
import 'package:ciu_announcement/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ciu_announcement/features/auth/domain/entities/user_entity.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';
import 'package:ciu_announcement/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final BaseNetworkInfo _baseNetworkInfo;

  AuthRepositoryImpl(this._remoteDataSource, this._baseNetworkInfo);

  @override
  Future<Either<BaseFailure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<BaseFailure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final userModel = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<BaseFailure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<BaseFailure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<BaseFailure, bool>> isLoggedIn() async {
    try {
      await _remoteDataSource.getCurrentUser();
      return const Right(true);
    } on UnauthorizedException {
      return const Right(false);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
