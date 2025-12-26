import 'package:flutter/material.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';

class AnnouncementCategoryDropdownWidget extends StatelessWidget {
  final AnnouncementCategory? selectedCategory;
  final ValueChanged<AnnouncementCategory?> onChanged;
  final String? Function(AnnouncementCategory?)? validator;

  const AnnouncementCategoryDropdownWidget({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AnnouncementCategory>(
      value: selectedCategory,
      onChanged: onChanged,
      validator: validator,
      decoration: const InputDecoration(
        labelText: 'Kategori',
        hintText: 'Seçiniz',
      ),
      items: AnnouncementCategory.values.map((category) {
        return DropdownMenuItem<AnnouncementCategory>(
          value: category,
          child: Text(category.displayName),
        );
      }).toList(),
    );
  }
}