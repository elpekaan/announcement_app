import 'package:flutter/material.dart';

class AuthPasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;

  const AuthPasswordFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
  });

  @override
  State<AuthPasswordFieldWidget> createState() =>
      _AuthPasswordFieldWidgetState();
}

class _AuthPasswordFieldWidgetState extends State<AuthPasswordFieldWidget> {
  bool _obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obsecureText,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obsecureText = !_obsecureText;
            });
          },
          icon: Icon(_obsecureText ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}
