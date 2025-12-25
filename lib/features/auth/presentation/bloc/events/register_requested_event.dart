import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/events/base/auth_event.dart';

class RegisterRequestedEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final UserRole role;

  const RegisterRequestedEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [name, email, password, role];
}