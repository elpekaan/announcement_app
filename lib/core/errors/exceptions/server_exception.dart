import 'package:ciu_announcement/core/errors/exceptions/base/base_exception.dart';

class ServerException extends BaseException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message (statusCode: $statusCode)';
}