enum AnnouncementTargetAudience {
  everyone('everyone', 'Everyone'),
  students('students', 'Students'),
  teachers('teachers', 'Teachers');

  final String value;
  final String displayName;

  const AnnouncementTargetAudience(this.value, this.displayName);

  static AnnouncementTargetAudience fromString(String audience) {
    return AnnouncementTargetAudience.values.firstWhere(
      (e) => e.value == audience.toLowerCase(),
      orElse: () => AnnouncementTargetAudience.everyone,
    );
  }
}