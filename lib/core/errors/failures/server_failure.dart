import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';

class ServerFailure extends BaseFailure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}