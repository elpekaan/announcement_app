import 'package:ciu_announcement/core/entities/base/base_entity.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';

class UserEntity extends BaseEntity {
  final String name;
  final String email;
  final UserRole role;

  UserEntity({
    required super.id,
    required this.name,
    required this.email,
    required this.role,
    required super.createdAt,
    super.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, email, role, createdAt, updatedAt];
}
