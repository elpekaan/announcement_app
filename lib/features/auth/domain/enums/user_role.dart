enum UserRole {
  student,
  teacher,
  admin,
  superAdmin;

  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Öğrenci';
      case UserRole.teacher:
        return 'Öğretmen';
      case UserRole.admin:
        return 'Admin';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }

  String get apiValue {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.teacher:
        return 'teacher';
      case UserRole.admin:
        return 'admin';
      case UserRole.superAdmin:
        return 'super_admin';
    }
  }

  static List<UserRole> get registerableRoles => [UserRole.student, UserRole.teacher];

  static UserRole fromString(String value) {
    switch (value) {
      case 'student':
        return UserRole.student;
      case 'teacher':
        return UserRole.teacher;
      case 'admin':
        return UserRole.admin;
      case 'super_admin':
        return UserRole.superAdmin;
      default:
        return UserRole.student;
    }
  }
}
