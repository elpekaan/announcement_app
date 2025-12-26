import 'package:flutter/material.dart';
import 'package:ciu_announcement/features/announcement/presentation/pages/announcement_list_page.dart';
import 'package:ciu_announcement/features/auth/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CIU Duyuru'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: const AnnouncementListPage(
        canCreate: true,
        canEdit: true,
        canDelete: true,
      ),
    );
  }
}