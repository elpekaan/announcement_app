enum AnnouncementPriority {
  normal,
  important,
  urgent;

  String get displayName {
    switch (this) {
      case AnnouncementPriority.normal:
        return 'Normal';
      case AnnouncementPriority.important:
        return 'Önemli';
      case AnnouncementPriority.urgent:
        return 'Acil';
    }
  }

  static AnnouncementPriority fromString(String value) {
    return AnnouncementPriority.values.firstWhere(
          (e) => e.name == value,
      orElse: () => AnnouncementPriority.normal,
    );
  }
}