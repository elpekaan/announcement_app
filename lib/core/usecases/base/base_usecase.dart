import 'package:dartz/dartz.dart';
import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';

abstract class BaseUseCase<T, Params> {
  Future<Either<BaseFailure, T>> call(Params params);
}
