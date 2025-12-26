import 'package:flutter/material.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';
import 'package:ciu_announcement/features/announcement/presentation/widgets/inputs/announcement_category_dropdown_widget.dart';
import 'package:ciu_announcement/features/announcement/presentation/widgets/inputs/announcement_priority_dropdown_widget.dart';
import 'package:ciu_announcement/features/announcement/presentation/widgets/inputs/announcement_target_audience_dropdown_widget.dart';
import 'package:ciu_announcement/features/auth/presentation/widgets/buttons/auth_submit_button_widget.dart';

class AnnouncementFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final AnnouncementCategory? selectedCategory;
  final AnnouncementPriority? selectedPriority;
  final AnnouncementTargetAudience? selectedTargetAudience;
  final ValueChanged<AnnouncementCategory?> onCategoryChanged;
  final ValueChanged<AnnouncementPriority?> onPriorityChanged;
  final ValueChanged<AnnouncementTargetAudience?> onTargetAudienceChanged;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String submitButtonText;

  const AnnouncementFormWidget({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.contentController,
    required this.selectedCategory,
    required this.selectedPriority,
    required this.selectedTargetAudience,
    required this.onCategoryChanged,
    required this.onPriorityChanged,
    required this.onTargetAudienceChanged,
    required this.onSubmit,
    this.isLoading = false,
    this.submitButtonText = 'Kaydet',
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Başlık',
              hintText: 'Duyuru başlığı',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Başlık gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: contentController,
            decoration: const InputDecoration(
              labelText: 'İçerik',
              hintText: 'Duyuru içeriği',
              alignLabelWithHint: true,
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'İçerik gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AnnouncementCategoryDropdownWidget(
            selectedCategory: selectedCategory,
            onChanged: onCategoryChanged,
            validator: (value) {
              if (value == null) {
                return 'Kategori seçiniz';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AnnouncementPriorityDropdownWidget(
            selectedPriority: selectedPriority,
            onChanged: onPriorityChanged,
            validator: (value) {
              if (value == null) {
                return 'Öncelik seçiniz';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AnnouncementTargetAudienceDropdownWidget(
            selectedTargetAudience: selectedTargetAudience,
            onChanged: onTargetAudienceChanged,
            validator: (value) {
              if (value == null) {
                return 'Hedef kitle seçiniz';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          AuthSubmitButtonWidget(
            text: submitButtonText,
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}