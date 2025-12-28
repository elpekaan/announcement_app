import 'package:ciu_announcement/features/auth/presentation/bloc/events/base/auth_event.dart';

class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginRequestedEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
