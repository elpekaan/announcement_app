import 'package:ciu_announcement/core/models/base/base_model.dart';
import 'package:ciu_announcement/features/auth/domain/entities/user_entity.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';

class UserModel extends BaseModel<UserEntity> {
  final String name;
  final String email;
  final UserRole role;

  UserModel({
    required super.id,
    required this.name,
    required this.email,
    required this.role,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.fromString(json['role'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['update_at'] != null ? DateTime.parse(json['update_at'] as String) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.value,
      'created_at': createdAt.toIso8601String(),
      'update_at': updatedAt?.toIso8601String() ?? '',
    };
  }

  @override
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
