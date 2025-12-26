import 'package:flutter/material.dart';
import 'package:ciu_announcement/core/theme/app_theme.dart';
import 'package:ciu_announcement/injection_container.dart';
import 'package:ciu_announcement/features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  runApp(const CiuAnnouncementApp());
}

class CiuAnnouncementApp extends StatelessWidget {
  const CiuAnnouncementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIU Announcement',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}