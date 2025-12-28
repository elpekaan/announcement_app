import 'package:flutter/material.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';

class AuthRoleDropdownWidget extends StatefulWidget {
  final UserRole? selectedRole;
  final ValueChanged<UserRole?> onChanged;
  final String? Function(UserRole?)? validator;
  final List<UserRole>? availableRoles;

  const AuthRoleDropdownWidget({
    super.key,
    required this.selectedRole,
    required this.onChanged,
    this.validator,
    this.availableRoles,
  });

  @override
  State<AuthRoleDropdownWidget> createState() => _AuthRoleDropdownWidgetState();
}

class _AuthRoleDropdownWidgetState extends State<AuthRoleDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    final roles = widget.availableRoles ?? UserRole.registerableRoles;
    
    return DropdownButtonFormField<UserRole>(
      decoration: const InputDecoration(
        labelText: 'Kullanıcı Tipi',
        hintText: 'Seçiniz',
      ),
      items: roles.map((role) {
        return DropdownMenuItem<UserRole>(
          value: role,
          child: Text(role.displayName),
        );
      }).toList(),
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
