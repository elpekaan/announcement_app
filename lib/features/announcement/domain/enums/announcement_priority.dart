enum AnnouncementPriority {
  normal('normal', 'Normal'),
  important('important', 'Important'),
  urgent('urgent', 'Urgent');

  final String value;
  final String displayName;

  const AnnouncementPriority(this.value, this.displayName);

  static AnnouncementPriority fromString(String priority) {
    return AnnouncementPriority.values.firstWhere(
      (e) => e.value == priority.toLowerCase(),
      orElse: () => AnnouncementPriority.normal,
    );
  }
}