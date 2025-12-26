import 'package:flutter/material.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';

class AnnouncementTargetAudienceDropdownWidget extends StatelessWidget {
  final AnnouncementTargetAudience? selectedTargetAudience;
  final ValueChanged<AnnouncementTargetAudience?> onChanged;
  final String? Function(AnnouncementTargetAudience?)? validator;

  const AnnouncementTargetAudienceDropdownWidget({
    super.key,
    required this.selectedTargetAudience,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AnnouncementTargetAudience>(
      value: selectedTargetAudience,
      onChanged: onChanged,
      validator: validator,
      decoration: const InputDecoration(
        labelText: 'Hedef Kitle',
        hintText: 'Seçiniz',
      ),
      items: AnnouncementTargetAudience.values.map((audience) {
        return DropdownMenuItem<AnnouncementTargetAudience>(
          value: audience,
          child: Text(audience.displayName),
        );
      }).toList(),
    );
  }
}