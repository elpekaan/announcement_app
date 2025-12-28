import 'package:flutter/material.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';

class AnnouncementPriorityDropdownWidget extends StatefulWidget {
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
  State<AnnouncementPriorityDropdownWidget> createState() => _AnnouncementPriorityDropdownWidgetState();
}

class _AnnouncementPriorityDropdownWidgetState extends State<AnnouncementPriorityDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AnnouncementPriority>(
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
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
