enum AnnouncementCategory {
  academic('academic', 'Academic'),
  administrative('administrative', 'Administrative'),
  event('event', 'Event'),
  urgent('urgent', 'Urgent');

  final String value;
  final String displayName;

  const AnnouncementCategory(this.value, this.displayName);

  static AnnouncementCategory fromString(String category) {
    return AnnouncementCategory.values.firstWhere(
      (e) => e.value == category.toLowerCase(),
      orElse: () => AnnouncementCategory.academic,
    );
  }
}
