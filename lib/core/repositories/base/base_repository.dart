import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';
import 'package:dartz/dartz.dart';

abstract class BaseRepository<T> {
  Future<Either<BaseFailure, List<T>>> getAll();

  Future<Either<BaseFailure, T>> getById(int id);

  Future<Either<BaseFailure, T>> create(T entity);

  Future<Either<BaseFailure, T>> update(T entity);

  Future<Either<BaseFailure, void>> delete(int id);
}
