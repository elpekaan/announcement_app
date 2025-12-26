import 'package:ciu_announcement/core/errors/exceptions/server_exception.dart';
import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:ciu_announcement/core/errors/failures/server_failure.dart';
import 'package:ciu_announcement/features/announcement/data/datasources/announcement_remote_datasource.dart';
import 'package:ciu_announcement/features/announcement/domain/entities/announcement_entity.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';
import 'package:ciu_announcement/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:dartz/dartz.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource _remoteDataSource;

  AnnouncementRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<BaseFailure, List<AnnouncementEntity>>> getAll() async {
    try {
      final models = await _remoteDataSource.getAll();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<BaseFailure, AnnouncementEntity>> getById(int id) async {
    try {
      final model = await _remoteDataSource.getById(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<BaseFailure, AnnouncementEntity>> create({
    required String title,
    required String content,
    required AnnouncementCategory category,
    required AnnouncementPriority priority,
    required AnnouncementTargetAudience targetAudience,
  }) async {
    try {
      final model = await _remoteDataSource.create(
        title: title,
        content: content,
        category: category,
        priority: priority,
        targetAudience: targetAudience
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<BaseFailure, AnnouncementEntity>> update({
    required int id,
    required String title,
    required String content,
    required AnnouncementCategory category,
    required AnnouncementPriority priority,
    required AnnouncementTargetAudience targetAudience,
  }) async {
    try {
      final model = await _remoteDataSource.update(
        id: id,
        title: title,
        content: content,
        category: category,
        priority: priority,
        targetAudience: targetAudience
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<BaseFailure, void>> delete(int id) async {
    try {
      await _remoteDataSource.delete(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}





















