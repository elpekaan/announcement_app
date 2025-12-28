import 'package:flutter/material.dart';
import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/core/theme/app_colors.dart';
import 'package:ciu_announcement/injection_container.dart';
import 'package:ciu_announcement/features/auth/domain/entities/user_entity.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';
import 'package:ciu_announcement/features/user/data/datasources/user_remote_datasource.dart';
import 'package:ciu_announcement/features/user/presentation/pages/user_create_page.dart';
import 'package:ciu_announcement/features/user/presentation/pages/user_edit_page.dart';

class UserListPage extends StatefulWidget {
  final UserEntity currentUser;

  const UserListPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final _dataSource = UserRemoteDataSource(sl<ApiClient>());
  List<UserEntity> _users = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final models = await _dataSource.getManageableUsers();
      setState(() {
        _users = models.map((m) => m.toEntity()).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteUser(UserEntity user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kullanıcıyı Sil'),
        content: Text('${user.name} kullanıcısını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _dataSource.delete(user.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kullanıcı silindi'), backgroundColor: Colors.green),
          );
          _loadUsers();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserCreatePage(currentUser: widget.currentUser),
      ),
    ).then((_) => _loadUsers());
  }

  void _navigateToEdit(UserEntity user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserEditPage(currentUser: widget.currentUser, targetUser: user),
      ),
    ).then((_) => _loadUsers());
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return Colors.purple;
      case UserRole.admin:
        return Colors.orange;
      case UserRole.teacher:
        return Colors.blue;
      case UserRole.student:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Yönetimi'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreate,
        child: const Icon(Icons.person_add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUsers,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : _users.isEmpty
                  ? const Center(child: Text('Yönetilebilir kullanıcı bulunamadı'))
                  : RefreshIndicator(
                      onRefresh: _loadUsers,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getRoleColor(user.role).withAlpha(50),
                                child: Text(
                                  user.name[0].toUpperCase(),
                                  style: TextStyle(color: _getRoleColor(user.role)),
                                ),
                              ),
                              title: Text(user.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.email, style: TextStyle(color: AppColors.textSecondary)),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(user.role).withAlpha(25),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      user.role.displayName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getRoleColor(user.role),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _navigateToEdit(user),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteUser(user),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
