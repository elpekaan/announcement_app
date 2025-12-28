enum AnnouncementCategory {
  academic,
  administrative,
  event,
  urgent;

  String get displayName {
    switch (this) {
      case AnnouncementCategory.academic:
        return 'Akademik';
      case AnnouncementCategory.administrative:
        return 'İdari';
      case AnnouncementCategory.event:
        return 'Etkinlik';
      case AnnouncementCategory.urgent:
        return 'Acil';
    }
  }

  static AnnouncementCategory fromString(String value) {
    return AnnouncementCategory.values.firstWhere(
          (e) => e.name == value,
      orElse: () => AnnouncementCategory.academic,
    );
  }
}