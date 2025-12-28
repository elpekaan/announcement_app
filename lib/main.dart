import 'package:flutter/material.dart';
import 'package:ciu_announcement/core/theme/app_theme.dart';
import 'package:ciu_announcement/core/storage/secure_storage.dart';
import 'package:ciu_announcement/injection_container.dart';
import 'package:ciu_announcement/features/auth/presentation/pages/login_page.dart';
import 'package:ciu_announcement/features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  final isLoggedIn = await SecureStorage.getToken() != null;

  runApp(CiuAnnouncementApp(isLoggedIn: isLoggedIn));
}

class CiuAnnouncementApp extends StatelessWidget {
  final bool isLoggedIn;

  const CiuAnnouncementApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIU Announcement',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}