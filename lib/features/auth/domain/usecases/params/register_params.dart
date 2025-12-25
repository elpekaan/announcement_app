import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';

class RegisterParams {
  final String name;
  final String email;
  final String password;
  final UserRole role;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}