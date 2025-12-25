import 'package:ciu_announcement/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/events/login_requested_event.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_authenticated_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_error_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/auth_loading_state.dart';
import 'package:ciu_announcement/features/auth/presentation/bloc/states/base/auth_state.dart';
import 'package:ciu_announcement/features/auth/presentation/pages/register_page.dart';
import 'package:ciu_announcement/features/auth/presentation/widgets/forms/login_form_widget.dart';
import 'package:ciu_announcement/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginRequestedEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign In')),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticatedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Welcome ${state.user.name}')),
              );
              // TODO: Navigate to home page
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      'CIU Announcement',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Log in to your account',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    LoginFormWidget(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onSubmit: () => _onSubmit(context),
                      isLoading: state is AuthLoadingState,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _navigateToRegister,
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
