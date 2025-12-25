import 'package:flutter/material.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';
import 'package:ciu_announcement/features/auth/presentation/widgets/inputs/auth_text_field_widget.dart';
import 'package:ciu_announcement/features/auth/presentation/widgets/inputs/auth_password_field_widget.dart';
import 'package:ciu_announcement/features/auth/presentation/widgets/inputs/auth_role_dropdown_widget.dart';
import 'package:ciu_announcement/features/auth/presentation/widgets/buttons/auth_submit_button_widget.dart';

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
          AuthTextFieldWidget(
            controller: nameController,
            labelText: 'Name & Surname',
            hintText: 'Please enter your name and surname',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name & Surname required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AuthTextFieldWidget(
            controller: emailController,
            labelText: 'Email',
            hintText: 'ornek@ciu.edu.tr',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email required';
              }
              if (!value.contains('@')) {
                return 'Invalid email format';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AuthRoleDropdownWidget(
            selectedRole: selectedRole,
            onChanged: onRoleChanged,
            validator: (value) {
              if (value == null) {
                return 'Role required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AuthPasswordFieldWidget(
            controller: passwordController,
            labelText: 'Password',
            hintText: 'Password must be at least 8 characters',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AuthPasswordFieldWidget(
            controller: confirmPasswordController,
            labelText: 'Password Confirmation',
            hintText: 'Please confirm your password',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password confirmation required';
              }
              if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          AuthSubmitButtonWidget(
            text: 'Register',
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}