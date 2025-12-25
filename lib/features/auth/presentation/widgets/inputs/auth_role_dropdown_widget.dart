import 'package:flutter/material.dart';
import 'package:ciu_announcement/features/auth/domain/enums/user_role.dart';

class AuthRoleDropdownWidget extends StatelessWidget {
  final UserRole? selectedRole;
  final ValueChanged<UserRole?> onChanged;
  final String? Function(UserRole?)? validator;

  const AuthRoleDropdownWidget({
    super.key,
    required this.selectedRole,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<UserRole>(
      value: selectedRole,
      onChanged: onChanged,
      validator: validator,
      decoration: const InputDecoration(
        labelText: 'Role',
        hintText: 'Please Select',
      ),
      items: UserRole.registerableRoles.map((role) {
        return DropdownMenuItem<UserRole>(
          value: role,
          child: Text(role.displayName),
        );
      }).toList(),
    );
  }
}