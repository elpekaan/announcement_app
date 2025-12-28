import 'package:flutter/material.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';

class RegisterFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final UserRole? selectedRole;
  final ValueChanged<UserRole?> onRoleChanged;
  final VoidCallback onSubmit;
  final bool isLoading;

  const RegisterFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Ad Soyad',
              hintText: 'Adınız Soyadınız',
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
            controller: emailController,
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
            controller: passwordController,
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
            controller: confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Şifre Tekrar',
              hintText: 'Şifrenizi tekrar girin',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Şifre tekrarı gerekli';
              }
              if (value != passwordController.text) {
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
            items: UserRole.registerableRoles.map((role) {
              return DropdownMenuItem<UserRole>(
                value: role,
                child: Text(role.displayName),
              );
            }).toList(),
            onChanged: onRoleChanged,
            validator: (value) {
              if (value == null) {
                return 'Kullanıcı tipi seçin';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Kayıt Ol'),
          ),
        ],
      ),
    );
  }
}
