import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ciu_announcement/injection_container.dart';
import 'package:ciu_announcement/features/auth/domain/entities/user_entity.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/events/logout_requested_event.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/events/get_current_user_event.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/base/auth_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_authenticated_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_unauthenticated_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_loading_state.dart';
import 'package:ciu_announcement/features/auth/presentation/pages/login_page.dart';
import 'package:ciu_announcement/features/announcement/presentation/pages/announcement_list_page.dart';
import 'package:ciu_announcement/features/user/presentation/pages/user_list_page.dart';
import 'package:ciu_announcement/features/profile/presentation/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const GetCurrentUserEvent()),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatelessWidget {
  const _HomePageView();

  bool _canCreateAnnouncement(UserRole role) {
    return role == UserRole.teacher || 
           role == UserRole.admin || 
           role == UserRole.superAdmin;
  }

  bool _canEditAnnouncement(UserRole role) {
    return role == UserRole.teacher || 
           role == UserRole.admin || 
           role == UserRole.superAdmin;
  }

  bool _canDeleteAnnouncement(UserRole role) {
    return role == UserRole.teacher || 
           role == UserRole.admin || 
           role == UserRole.superAdmin;
  }

  bool _canManageAllAnnouncements(UserRole role) {
    return role == UserRole.admin || role == UserRole.superAdmin;
  }

  bool _canManageUsers(UserRole role) {
    return role != UserRole.student;
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(const LogoutRequestedEvent());
  }

  void _navigateToUserManagement(BuildContext context, UserEntity user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserListPage(currentUser: user),
      ),
    );
  }

  void _navigateToProfile(BuildContext context, UserEntity user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePage(currentUser: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticatedState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticatedState) {
          final user = state.user;
          
          final canCreate = _canCreateAnnouncement(user.role);
          final canEdit = _canEditAnnouncement(user.role);
          final canDelete = _canDeleteAnnouncement(user.role);
          final canManageAll = _canManageAllAnnouncements(user.role);
          final canManageUsers = _canManageUsers(user.role);

          return Scaffold(
            appBar: AppBar(
              title: const Text('CIU Duyuru'),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'profile':
                        _navigateToProfile(context, user);
                        break;
                      case 'users':
                        _navigateToUserManagement(context, user);
                        break;
                      case 'logout':
                        _logout(context);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'profile',
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Profilim'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    if (canManageUsers)
                      PopupMenuItem<String>(
                        value: 'users',
                        child: ListTile(
                          leading: const Icon(Icons.people),
                          title: const Text('Kullanıcı Yönetimi'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.role.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnnouncementListPage(
                    currentUserId: user.id,
                    canCreate: canCreate,
                    canEdit: canEdit,
                    canDelete: canDelete,
                    canManageAll: canManageAll,
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
