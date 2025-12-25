abstract class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String refreshToken = '/auth/refresh';

  static const String announcement = '/announcement';
  static String announcementById(int id) => '/announcement/$id';
}