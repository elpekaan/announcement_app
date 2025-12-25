import 'package:dartz/dartz.dart';
import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';

abstract class BaseUseCase<Type, Params> {
  Future<Either<BaseFailure, Type>> call(Params params);
}
