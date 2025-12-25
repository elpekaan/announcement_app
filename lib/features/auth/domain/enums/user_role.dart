enum UserRole {
  student('student', 'Student'),
  teacher('teacher', 'Teacher'),
  admin('admin', 'Admin');

  final String value;
  final String displayName;

  const UserRole(this.value, this.displayName);

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
          (e) => e.value == role.toLowerCase(),
      orElse: () => UserRole.student,
    );
  }

  static List<UserRole> get registerableRoles => [student, teacher];
}
