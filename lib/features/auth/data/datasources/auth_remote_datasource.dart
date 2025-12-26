import 'package:ciu_announcement/features/auth/data/models/user_model.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();
}