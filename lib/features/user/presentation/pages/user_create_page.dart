import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ciu_announcement/core/network/api_client.dart';
import 'package:ciu_announcement/injection_container.dart';
import 'package:ciu_announcement/features/auth/domain/entities/user_entity.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';

class UserCreatePage extends StatefulWidget {
  final UserEntity currentUser;

  const UserCreatePage({
    super.key,
    required this.currentUser,
  });

  @override
  State<UserCreatePage> createState() => _UserCreatePageState();
}

class _UserCreatePageState extends State<UserCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  UserRole? _selectedRole;
  List<UserRole> _availableRoles = [];
  bool _isLoading = false;
  bool _isLoadingRoles = true;

  @override
  void initState() {
    super.initState();
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
      final apiClient = sl<ApiClient>();
      final response = await apiClient.dio.get('/users/creatable-roles');
      
      if (response.data['success'] == true) {
        final List<dynamic> rolesData = response.data['data'];
        setState(() {
          _availableRoles = rolesData
              .map((r) => UserRole.fromString(r['value']))
              .toList();
          _isLoadingRoles = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingRoles = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Roller yüklenemedi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createUser() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen kullanıcı tipi seçin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiClient = sl<ApiClient>();
      final response = await apiClient.dio.post('/users', data: {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
        'role': _selectedRole!.apiValue,
      });

      if (response.data['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kullanıcı oluşturuldu'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } on DioException catch (e) {
      String message = 'Bir hata oluştu';
      if (e.response?.statusCode == 403) {
        message = e.response?.data['message'] ?? 'Yetkiniz yok';
      } else if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null) {
          if (errors['email'] != null) {
            message = errors['email'][0];
          } else if (errors['password'] != null) {
            message = errors['password'][0];
          } else {
            message = e.response?.data['message'] ?? 'Validasyon hatası';
          }
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
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
        title: const Text('Kullanıcı Ekle'),
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
                        hintText: 'Kullanıcının adı soyadı',
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
                        hintText: 'ornek@ciu.edu.tr',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email gerekli';
                        }
                        if (!value.contains('@')) {
                          return 'Geçerli bir email girin';
                        }
                        if (!value.endsWith('@ciu.edu.tr')) {
                          return 'Sadece @ciu.edu.tr uzantılı mail adresleri kabul edilmektedir';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Şifre',
                        hintText: 'En az 6 karakter',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şifre gerekli';
                        }
                        if (value.length < 6) {
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
                        hintText: 'Şifreyi tekrar girin',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şifre tekrarı gerekli';
                        }
                        if (value != _passwordController.text) {
                          return 'Şifreler eşleşmiyor';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<UserRole>(
                      decoration: const InputDecoration(
                        labelText: 'Kullanıcı Tipi',
                        hintText: 'Seçiniz',
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
                      validator: (value) {
                        if (value == null) {
                          return 'Kullanıcı tipi seçin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _createUser,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Kullanıcı Oluştur'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
