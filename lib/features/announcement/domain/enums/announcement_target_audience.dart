enum AnnouncementTargetAudience {
  everyone,
  students,
  teachers;

  String get displayName {
    switch (this) {
      case AnnouncementTargetAudience.everyone:
        return 'Herkes';
      case AnnouncementTargetAudience.students:
        return 'Öğrenciler';
      case AnnouncementTargetAudience.teachers:
        return 'Öğretmenler';
    }
  }

  static AnnouncementTargetAudience fromString(String value) {
    return AnnouncementTargetAudience.values.firstWhere(
          (e) => e.name == value,
      orElse: () => AnnouncementTargetAudience.everyone,
    );
  }
}