import 'package:flutter/material.dart';
import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/injection_container.dart';
import 'package:ciu_announcement/features/auth/domain/entities/user_entity.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';
import 'package:ciu_announcement/features/user/data/datasources/user_remote_datasource.dart';

class UserEditPage extends StatefulWidget {
  final UserEntity currentUser;
  final UserEntity targetUser;

  const UserEditPage({
    super.key,
    required this.currentUser,
    required this.targetUser,
  });

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _dataSource = UserRemoteDataSource(sl<ApiClient>());
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  UserRole? _selectedRole;
  List<UserRole> _availableRoles = [];
  bool _isLoading = false;
  bool _isLoadingRoles = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.targetUser.name);
    _emailController = TextEditingController(text: widget.targetUser.email);
    _selectedRole = widget.targetUser.role;
    _loadCreatableRoles();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadCreatableRoles() async {
    try {
      final roles = await _dataSource.getCreatableRoles();
      setState(() {
        _availableRoles = roles;
        _isLoadingRoles = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingRoles = false;
      });
    }
  }

  Future<void> _updateUser() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _dataSource.update(
        id: widget.targetUser.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
        passwordConfirmation: _confirmPasswordController.text.isNotEmpty ? _confirmPasswordController.text : null,
        role: _selectedRole,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı güncellendi'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Düzenle'),
      ),
      body: _isLoadingRoles
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Ad Soyad',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ad soyad gerekli';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email gerekli';
                        }
                        if (!value.endsWith('@ciu.edu.tr')) {
                          return 'Sadece @ciu.edu.tr uzantılı mail adresleri kabul edilmektedir';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<UserRole>(
                      decoration: const InputDecoration(
                        labelText: 'Kullanıcı Tipi',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      items: _availableRoles.map((role) {
                        return DropdownMenuItem<UserRole>(
                          value: role,
                          child: Text(role.displayName),
                        );
                      }).toList(),
                      onChanged: (role) {
                        setState(() {
                          _selectedRole = role;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Şifre Değiştir (Opsiyonel)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Yeni Şifre',
                        hintText: 'Boş bırakırsanız değişmez',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && value.length < 6) {
                          return 'Şifre en az 6 karakter olmalı';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Şifre Tekrar',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (_passwordController.text.isNotEmpty && value != _passwordController.text) {
                          return 'Şifreler eşleşmiyor';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _updateUser,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Güncelle'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
