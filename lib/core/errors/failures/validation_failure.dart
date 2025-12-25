import 'package:ciu_announcement/core/errors/failures/base/base_failure.dart';

class ValidationFailure extends BaseFailure{
  final Map<String, List<String>> errors;

  const ValidationFailure(super.message, this.errors);

  @override
  List<Object?> get props => [message, errors];
}