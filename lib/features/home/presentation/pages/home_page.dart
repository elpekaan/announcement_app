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
import 'package:ciu_announcement/features/user/presentation/pages/user_create_page.dart';

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

  bool _canCreateUsers(UserRole role) {
    return role == UserRole.admin || role == UserRole.superAdmin;
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(const LogoutRequestedEvent());
  }

  void _navigateToUserCreate(BuildContext context, UserEntity user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserCreatePage(currentUser: user),
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
          final canCreateUsers = _canCreateUsers(user.role);

          return Scaffold(
            appBar: AppBar(
              title: const Text('CIU Duyuru'),
              actions: [
                if (canCreateUsers)
                  IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () => _navigateToUserCreate(context, user),
                    tooltip: 'Kullanıcı Ekle',
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Container(
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
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _logout(context),
                ),
              ],
            ),
            body: AnnouncementListPage(
              currentUserId: user.id,
              canCreate: canCreate,
              canEdit: canEdit,
              canDelete: canDelete,
              canManageAll: canManageAll,
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
