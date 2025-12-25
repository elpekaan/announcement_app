import 'package:ciu_announcement/features/auth/presentation/widgets/buttons/auth_submit_button_widget.dart';
import 'package:ciu_announcement/features/auth/presentation/widgets/inputs/auth_password_field_widget.dart';
import 'package:ciu_announcement/features/auth/presentation/widgets/inputs/auth_text_field_widget.dart';
import 'package:flutter/cupertino.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final bool isLoading;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
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
            controller: emailController,
            labelText: 'Email',
            hintText: 'example@ciu.edu.tr',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Invalid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AuthPasswordFieldWidget(
            controller: passwordController,
            labelText: 'Password',
            hintText: 'Please enter your password',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          AuthSubmitButtonWidget(
            text: 'Sign In',
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
