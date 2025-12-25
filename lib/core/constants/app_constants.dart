abstract class AppConstants {
  static const String appName = 'CIU Announcement';
  static const String baseURL = 'http://10.0.2.2:8000/api';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxFileSize = 2 * 1024 * 1024;
}