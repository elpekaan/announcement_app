class AppConstants {
  static const String appName = 'CIU Announcement';

  // MacBook için localhost (iOS Simulator / Web)
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Android Emulator için bu olacak:
  // static const String baseUrl = 'http://10.0.2.2:8000/api';

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const int maxFileSize = 2 * 1024 * 1024; // 2MB
}