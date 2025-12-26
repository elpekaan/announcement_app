import 'package:flutter/material.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';

class AnnouncementPriorityDropdownWidget extends StatelessWidget {
  final AnnouncementPriority? selectedPriority;
  final ValueChanged<AnnouncementPriority?> onChanged;
  final String? Function(AnnouncementPriority?)? validator;

  const AnnouncementPriorityDropdownWidget({
    super.key,
    required this.selectedPriority,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AnnouncementPriority>(
      value: selectedPriority,
      onChanged: onChanged,
      validator: validator,
      decoration: const InputDecoration(
        labelText: 'Öncelik',
        hintText: 'Seçiniz',
      ),
      items: AnnouncementPriority.values.map((priority) {
        return DropdownMenuItem<AnnouncementPriority>(
          value: priority,
          child: Text(priority.displayName),
        );
      }).toList(),
    );
  }
}