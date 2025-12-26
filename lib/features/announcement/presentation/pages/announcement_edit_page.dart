import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ciu_announcement/injection_container.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_category.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_priority.dart';
import 'package:ciu_announcement/features/announcement/domain/enums/announcement_target_audience.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/get_announcement_by_id_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/events/update_announcement_event.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/base/announcement_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_loading_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_detail_loaded_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_updated_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/bloc/states/announcement_error_state.dart';
import 'package:ciu_announcement/features/announcement/presentation/widgets/forms/announcement_form_widget.dart';

class AnnouncementEditPage extends StatefulWidget {
  final int announcementId;

  const AnnouncementEditPage({
    super.key,
    required this.announcementId,
  });

  @override
  State<AnnouncementEditPage> createState() => _AnnouncementEditPageState();
}

class _AnnouncementEditPageState extends State<AnnouncementEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  AnnouncementCategory? _selectedCategory;
  AnnouncementPriority? _selectedPriority;
  AnnouncementTargetAudience? _selectedTargetAudience;
  bool _isInitialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _initializeForm(AnnouncementDetailLoadedState state) {
    if (!_isInitialized) {
      _titleController.text = state.announcement.title;
      _contentController.text = state.announcement.content;
      _selectedCategory = state.announcement.category;
      _selectedPriority = state.announcement.priority;
      _selectedTargetAudience = state.announcement.targetAudience;
      _isInitialized = true;
    }
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AnnouncementBloc>().add(
        UpdateAnnouncementEvent(
          id: widget.announcementId,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          category: _selectedCategory!,
          priority: _selectedPriority!,
          targetAudience: _selectedTargetAudience!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AnnouncementBloc>()..add(GetAnnouncementByIdEvent(widget.announcementId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Duyuru Düzenle'),
        ),
        body: BlocConsumer<AnnouncementBloc, AnnouncementState>(
          listener: (context, state) {
            if (state is AnnouncementUpdatedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Duyuru güncellendi')),
              );
              Navigator.pop(context);
            } else if (state is AnnouncementErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AnnouncementLoadingState && !_isInitialized) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AnnouncementDetailLoadedState) {
              _initializeForm(state);
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: AnnouncementFormWidget(
                  formKey: _formKey,
                  titleController: _titleController,
                  contentController: _contentController,
                  selectedCategory: _selectedCategory,
                  selectedPriority: _selectedPriority,
                  selectedTargetAudience: _selectedTargetAudience,
                  onCategoryChanged: (value) {
                    setState(() => _selectedCategory = value);
                  },
                  onPriorityChanged: (value) {
                    setState(() => _selectedPriority = value);
                  },
                  onTargetAudienceChanged: (value) {
                    setState(() => _selectedTargetAudience = value);
                  },
                  onSubmit: () => _onSubmit(context),
                  isLoading: state is AnnouncementLoadingState && _isInitialized,
                  submitButtonText: 'Güncelle',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}